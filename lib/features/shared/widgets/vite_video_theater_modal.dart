import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../app/theme/colors.dart';

/// Native Landscape Fullscreen Video Player with clean, icon-only controls.
///
/// - Automatically enters immersive landscape orientation (`landscapeLeft` /
///   `landscapeRight`) when opened so 16:9 videos fill 100% of the screen
///   without cropping burned-in subtitles.
/// - Restores portrait orientation and edge-to-edge system UI when closed.
/// - Uses icon-only controls (no text labels) and flexible layout constraints
///   so the bottom control bar never overflows on any screen width.
class ViteVideoTheaterModal extends StatefulWidget {
  final VideoPlayerController controller;
  final String? caption;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const ViteVideoTheaterModal({
    super.key,
    required this.controller,
    this.caption,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  State<ViteVideoTheaterModal> createState() => _ViteVideoTheaterModalState();
}

class _ViteVideoTheaterModalState extends State<ViteVideoTheaterModal> {
  final TransformationController _zoomController = TransformationController();
  late bool _isMuted;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _isMuted = widget.isMuted;
    widget.controller.addListener(_onControllerUpdate);
    _enterFullscreenLandscape();
  }

  Future<void> _enterFullscreenLandscape() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<void> _exitFullscreenToPortrait() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    _zoomController.dispose();
    _exitFullscreenToPortrait();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    final controller = widget.controller;
    if (controller.value.isPlaying) {
      await controller.pause();
      if (mounted) {
        setState(() => _showControls = true);
      }
    } else {
      final duration = controller.value.duration;
      final position = controller.value.position;
      if (duration > Duration.zero &&
          position >= duration - const Duration(milliseconds: 250)) {
        await controller.seekTo(Duration.zero);
      }
      await controller.play();
    }
  }

  void _handleMuteToggle() {
    widget.onToggleMute();
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _closeModal() {
    _exitFullscreenToPortrait();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.controller.value;
    final aspectRatio = value.aspectRatio > 0 ? value.aspectRatio : 16 / 9;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _exitFullscreenToPortrait();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // 1. Fullscreen 16:9 Video Canvas (BoxFit.contain -> zero cropped subtitles)
            GestureDetector(
              onTap: () => setState(() => _showControls = !_showControls),
              behavior: HitTestBehavior.opaque,
              child: InteractiveViewer(
                transformationController: _zoomController,
                minScale: 1.0,
                maxScale: 3.0,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: VideoPlayer(widget.controller),
                  ),
                ),
              ),
            ),

            // 2. Center Play Icon when Paused
            if (!value.isPlaying)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 46,
                    ),
                  ),
                ),
              ),

            // 3. Top-Right Icon-Only Close Button
            if (_showControls || !value.isPlaying)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, right: 16.0),
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: InkWell(
                        key: const Key('theater_close_button'),
                        onTap: _closeModal,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // 4. Bottom Icon-Only Scrubber & Controls Bar (Overflow-proof)
            if (_showControls || !value.isPlaying)
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (value.isInitialized)
                            VideoProgressIndicator(
                              widget.controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              colors: const VideoProgressColors(
                                playedColor: AppColors.secondary,
                                bufferedColor: Colors.white38,
                                backgroundColor: Colors.white24,
                              ),
                            ),
                          Row(
                            children: [
                              InkWell(
                                onTap: _togglePlayPause,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    value.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              InkWell(
                                onTap: _handleMuteToggle,
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    _isMuted
                                        ? Icons.volume_off_rounded
                                        : Icons.volume_up_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                key: const Key('theater_collapse_button'),
                                onTap: _closeModal,
                                borderRadius: BorderRadius.circular(20),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.fullscreen_exit_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
