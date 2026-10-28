import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../app/theme/colors.dart';
import '../../../core/utils/video_asset_helper.dart';
import '../../vite_guide/widgets/vite_voice_guide_button.dart';
import 'vite_video_theater_modal.dart';

class ViteVideoPlayer extends StatefulWidget {
  final String assetPath;
  final bool autoPlay;
  final bool looping;
  final double aspectRatio;
  final String? caption;
  final double borderRadius;

  const ViteVideoPlayer({
    super.key,
    required this.assetPath,
    this.autoPlay = true,
    this.looping = false,
    this.aspectRatio = 16 / 9,
    this.caption,
    this.borderRadius = 20,
  });

  @override
  State<ViteVideoPlayer> createState() => _ViteVideoPlayerState();
}

class _ViteVideoPlayerState extends State<ViteVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    viteVoiceGuideActiveNotifier.addListener(_onVoiceGuideStateChanged);
    _initializePlayer();
  }

  void _onVoiceGuideStateChanged() {
    final controller = _controller;
    if (controller == null || !_isInitialized || !mounted) return;
    if (viteVoiceGuideActiveNotifier.value) {
      controller.setVolume(0.0);
    } else if (!_isMuted) {
      controller.setVolume(1.0);
    }
  }

  @override
  void didUpdateWidget(covariant ViteVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _controller?.removeListener(_videoListener);
      _controller?.dispose();
      _controller = null;
      _isInitialized = false;
      _hasError = false;
      _initializePlayer();
    }
  }

  void _videoListener() {
    if (!mounted) return;
    if (_controller != null && _controller!.value.hasError) {
      debugPrint(
        'Video player runtime error for ${widget.assetPath}: ${_controller!.value.errorDescription}',
      );
      setState(() {
        _hasError = true;
        _isInitialized = false;
      });
    } else {
      setState(() {});
    }
  }

  Future<void> _initializePlayer() async {
    final oldController = _controller;
    _controller = null;
    if (oldController != null) {
      oldController.removeListener(_videoListener);
      oldController.dispose();
    }

    try {
      final controller = await VideoAssetHelper.createAndInitialize(
        widget.assetPath,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller = controller;
      await controller.setLooping(widget.looping);
      await controller.setVolume(1.0);
      if (widget.autoPlay) {
        await controller.play();
        await controller.setVolume(1.0);
      }
      if (mounted) {
        controller.addListener(_videoListener);
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
      } else {
        controller.dispose();
      }
    } catch (e, stackTrace) {
      debugPrint('Error initializing video ${widget.assetPath}: $e\n$stackTrace');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
      }
    }
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;
    if (controller == null || !_isInitialized) return;
    if (controller.value.isPlaying) {
      await controller.pause();
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

  void _toggleMute() {
    if (_controller == null || !_isInitialized) return;
    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  Future<void> _openLargeView() async {
    final controller = _controller;
    if (controller == null || !_isInitialized) return;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fermer la vue agrandie',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return ViteVideoTheaterModal(
          controller: controller,
          caption: widget.caption,
          isMuted: _isMuted,
          onToggleMute: _toggleMute,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    viteVoiceGuideActiveNotifier.removeListener(_onVoiceGuideStateChanged);
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isInitialized && _controller != null)
              GestureDetector(
                onTap: _togglePlayPause,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              )
            else if (_hasError)
              Container(
                color: AppColors.darkBackground,
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.emergency,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Impossible de charger la vidéo',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: _initializePlayer,
                        icon: const Icon(
                          Icons.refresh,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                        label: const Text(
                          'Réessayer',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                color: AppColors.darkBackground,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                  ),
                ),
              ),

            // Controls overlay when initialized
            if (_isInitialized && _controller != null) ...[
              if (!_controller!.value.isPlaying)
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

              // Bottom control bar: Play/Pause, Caption, Mute, and Large View ("Agrandir")
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.78),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _togglePlayPause,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: _controller!.value.isPlaying ? 'Pause' : 'Lecture',
                      ),
                      if (widget.caption != null) ...[
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.caption!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else
                        const Spacer(),
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _toggleMute,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: _isMuted ? 'Activer le son' : 'Couper le son',
                      ),
                      const SizedBox(width: 2),
                      IconButton(
                        key: const Key('vite_video_expand_button'),
                        icon: const Icon(
                          Icons.open_in_full_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: _openLargeView,
                        constraints: const BoxConstraints(
                          minWidth: 38,
                          minHeight: 38,
                        ),
                        padding: EdgeInsets.zero,
                        tooltip: 'Agrandir la vidéo',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
