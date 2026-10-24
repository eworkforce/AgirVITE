import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../core/utils/video_asset_helper.dart';

/// Fullscreen Intro Video Screen displayed after app launch/splash
/// and directly before the initial BrandScreen welcome page.
class IntroVideoScreen extends StatefulWidget {
  const IntroVideoScreen({super.key});

  @override
  State<IntroVideoScreen> createState() => _IntroVideoScreenState();
}

class _IntroVideoScreenState extends State<IntroVideoScreen> {
  static const String _videoAssetPath = 'assets/videos/intro_vite_9x16.mp4';
  
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _hasNavigated = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    // Enable total immersive fullscreen mode (hiding system bars)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    final oldController = _controller;
    _controller = null;
    if (oldController != null) {
      oldController.removeListener(_onVideoProgress);
      oldController.dispose();
    }

    try {
      final controller = await VideoAssetHelper.createAndInitialize(
        _videoAssetPath,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller = controller;
      await controller.setLooping(false);
      await controller.setVolume(1.0);

      controller.addListener(_onVideoProgress);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _hasError = false;
        });
        await controller.play();
        // Re-affirm volume on the active audio track once playback begins
        await controller.setVolume(1.0);
      } else {
        controller.dispose();
      }
    } catch (e) {
      debugPrint('IntroVideoScreen: error initializing video $_videoAssetPath: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
      }
    }
  }

  void _toggleMute() {
    final controller = _controller;
    if (controller == null) return;
    setState(() {
      _isMuted = !_isMuted;
      controller.setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _onVideoProgress() {
    if (!mounted || _hasNavigated) return;

    final controller = _controller;
    if (controller == null) return;

    if (controller.value.hasError) {
      debugPrint('IntroVideoScreen runtime error: ${controller.value.errorDescription}');
      return;
    }

    // Auto-advance when playback reaches the end of the video
    if (controller.value.isInitialized &&
        controller.value.duration > Duration.zero &&
        controller.value.position >= controller.value.duration) {
      _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    try {
      if (_isInitialized && _controller != null) {
        _controller!.pause();
      }
    } catch (_) {}

    // Restore standard edge-to-edge system UI before leaving fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (mounted) {
      context.go('/onboarding/brand');
    }
  }

  @override
  void dispose() {
    // Ensure system UI is restored even if user navigates back or unmounts
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (_controller != null) {
      _controller!.removeListener(_onVideoProgress);
      _controller!.dispose();
      _controller = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Fullscreen Video Player (immersive 9:16 cover)
          if (_isInitialized && _controller != null)
            GestureDetector(
              onTap: () {
                // Tapping video toggles play/pause
                final controller = _controller!;
                if (controller.value.isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
                setState(() {});
              },
              behavior: HitTestBehavior.opaque,
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width > 0
                        ? _controller!.value.size.width
                        : 720,
                    height: _controller!.value.size.height > 0
                        ? _controller!.value.size.height
                        : 1280,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),
            )
          else if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_circle_outline_rounded,
                      size: 64,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Agir V.I.T.E.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Chaque minute compte pour sauver des vies.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _hasError = false;
                              _isInitialized = false;
                            });
                            _initializePlayer();
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                          label: const Text('Réessayer', style: TextStyle(color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _navigateToWelcome,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Continuer'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
              ),
            ),

          // 2. Play/Pause subtle indicator when user paused manually
          if (_isInitialized && _controller != null && !_controller!.value.isPlaying && !_hasNavigated)
            Center(
              child: IgnorePointer(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),

          // 3. Audio / Volume Control Overlay (Top-Right)
          if (_isInitialized && _controller != null && !_hasNavigated)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, right: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Material(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: _toggleMute,
                          borderRadius: BorderRadius.circular(24),
                          splashColor: Colors.white.withValues(alpha: 0.2),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              _isMuted
                                  ? Icons.volume_off_rounded
                                  : Icons.volume_up_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // 4. Skip Button ("Passer la vidéo") Overlay at footage / bottom
          if (!_hasError)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0, left: 24.0, right: 24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.35),
                          width: 1,
                        ),
                      ),
                      child: InkWell(
                        onTap: _navigateToWelcome,
                        borderRadius: BorderRadius.circular(30),
                        splashColor: Colors.white.withValues(alpha: 0.2),
                        highlightColor: Colors.white.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Passer la vidéo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
