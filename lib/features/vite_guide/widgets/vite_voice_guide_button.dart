import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../app/theme/colors.dart';
import '../../../core/utils/video_asset_helper.dart';

/// Global notifier indicating whether a V.I.T.E. voice guide audio clip is playing,
/// allowing [ViteVideoPlayer] to automatically pause/mute video audio so they never clash.
final ValueNotifier<bool> viteVoiceGuideActiveNotifier =
    ValueNotifier<bool>(false);

class ViteVoiceGuideButton extends StatefulWidget {
  final String audioAssetPath;
  final Color accentColor;

  const ViteVoiceGuideButton({
    super.key,
    required this.audioAssetPath,
    this.accentColor = AppColors.primary,
  });

  @override
  State<ViteVoiceGuideButton> createState() => _ViteVoiceGuideButtonState();
}

class _ViteVoiceGuideButtonState extends State<ViteVoiceGuideButton> {
  VideoPlayerController? _audioController;
  bool _isPlaying = false;
  bool _isLoading = false;

  void _audioListener() {
    final controller = _audioController;
    if (controller == null || !mounted) return;

    final value = controller.value;
    if (value.isInitialized &&
        !value.isPlaying &&
        value.position >= value.duration &&
        value.duration > Duration.zero) {
      _stopPlayback();
    }
  }

  Future<void> _toggleAudio() async {
    HapticFeedback.selectionClick();
    if (_isLoading) return;

    if (_isPlaying) {
      await _stopPlayback();
      return;
    }

    setState(() => _isLoading = true);
    viteVoiceGuideActiveNotifier.value = true;

    try {
      var controller = _audioController;
      if (controller == null || !controller.value.isInitialized) {
        controller = await VideoAssetHelper.createAndInitialize(
          widget.audioAssetPath,
        );
        controller.addListener(_audioListener);
        _audioController = controller;
      }

      await controller.setLooping(false);
      await controller.setVolume(1.0);
      await controller.seekTo(Duration.zero);
      await controller.play();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing voice guide ${widget.audioAssetPath}: $e');
      viteVoiceGuideActiveNotifier.value = false;
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isPlaying = false;
        });
      }
    }
  }

  Future<void> _stopPlayback() async {
    final controller = _audioController;
    if (controller != null && controller.value.isInitialized) {
      await controller.pause();
      await controller.seekTo(Duration.zero);
    }
    viteVoiceGuideActiveNotifier.value = false;
    if (mounted) {
      setState(() {
        _isPlaying = false;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    final controller = _audioController;
    if (controller != null) {
      controller.removeListener(_audioListener);
      controller.dispose();
    }
    if (_isPlaying) {
      viteVoiceGuideActiveNotifier.value = false;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _isPlaying ? AppColors.emergency : widget.accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('voice_guide_button_${widget.audioAssetPath}'),
        onTap: _toggleAudio,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: _isPlaying
                ? AppColors.emergency
                : color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isPlaying
                  ? AppColors.emergency
                  : color.withValues(alpha: 0.45),
              width: 1.3,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isLoading)
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              else
                Icon(
                  _isPlaying
                      ? Icons.stop_circle_rounded
                      : Icons.volume_up_rounded,
                  size: 16,
                  color: _isPlaying ? Colors.white : color,
                ),
              const SizedBox(width: 5),
              Text(
                _isPlaying ? 'Arrêter' : 'Écouter',
                style: TextStyle(
                  color: _isPlaying ? Colors.white : color,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
