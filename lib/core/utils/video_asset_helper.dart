import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

/// Helper utility for creating robust, resilient [VideoPlayerController] instances
/// from packaged Flutter assets.
///
/// On certain Android devices and OS versions (Android 10+), Media3 ExoPlayer's
/// `AssetDataSource` can fail to initialize or seek on large packaged APK assets
/// when `AssetManager.openFd` cannot provide a continuous file descriptor or when
/// zip container constraints prevent seeking.
///
/// This helper attempts standard asset loading first. If initialization fails,
/// it smoothly falls back to extracting the asset bytes via [rootBundle] to a
/// local temporary cache file and playing via [VideoPlayerController.file], which
/// guarantees full random-access seeking and hardware playback compatibility.
class VideoAssetHelper {
  const VideoAssetHelper._();

  /// Creates and initializes a [VideoPlayerController] for the given [assetPath].
  ///
  /// Throws an exception only if both the direct asset initialization and the
  /// extracted cached file fallback fail.
  static Future<VideoPlayerController> createAndInitialize(
    String assetPath, {
    VideoPlayerOptions? videoPlayerOptions,
  }) async {
    // 1. Primary path: direct asset playback
    try {
      final controller = VideoPlayerController.asset(
        assetPath,
        videoPlayerOptions: videoPlayerOptions,
      );
      await controller.initialize();
      if (controller.value.hasError) {
        final err = controller.value.errorDescription;
        controller.dispose();
        throw Exception(err ?? 'Asset initialization error');
      }
      return controller;
    } catch (assetError, stackTrace) {
      debugPrint(
        'VideoAssetHelper: direct asset loading failed for "$assetPath" ($assetError). '
        'Falling back to local cached file extraction...',
      );
      debugPrintStack(stackTrace: stackTrace);
    }

    // 2. Fallback path: extract asset to temporary cache directory
    try {
      final tempDir = await getTemporaryDirectory();
      final cacheDir = Directory('${tempDir.path}/video_asset_cache');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }

      // Sanitize the asset path to create a deterministic, safe filename
      final safeName = assetPath.replaceAll(RegExp(r'[^\w\.-]'), '_');
      final targetFile = File('${cacheDir.path}/$safeName');

      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // Write or overwrite if size does not match
      if (!await targetFile.exists() || (await targetFile.length()) != bytes.length) {
        await targetFile.writeAsBytes(bytes, flush: true);
      }

      final fileController = VideoPlayerController.file(
        targetFile,
        videoPlayerOptions: videoPlayerOptions,
      );
      await fileController.initialize();
      debugPrint(
        'VideoAssetHelper: successfully initialized via cached file fallback: ${targetFile.path}',
      );
      return fileController;
    } catch (fallbackError, fallbackStack) {
      debugPrint(
        'VideoAssetHelper: fallback file extraction also failed for "$assetPath": $fallbackError',
      );
      debugPrintStack(stackTrace: fallbackStack);
      rethrow;
    }
  }
}
