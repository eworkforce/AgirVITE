import 'package:flutter_riverpod/flutter_riverpod.dart';

final ocrServiceProvider = Provider((ref) => OCRService());

class OCRService {
  // Stub for Phase 2 - Simulate AI extraction
  Future<Map<String, int>> extractFromImage(String imagePath) async {
    // Simulate delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock data (simulating a successful read)
    // In Phase 3, we connect to Gemini API here
    return {
      'systolic': 124,
      'diastolic': 82,
      'pulse': 72,
    };
  }
}
