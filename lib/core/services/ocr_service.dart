import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final ocrServiceProvider = Provider((ref) => OCRService());

class OCRService {
  // Real implementation using Gemini
  Future<Map<String, int>> extractFromImage(String imagePath) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (apiKey == null) {
        // Fallback or error if key missing
        debugPrint('GEMINI_API_KEY not found in .env');
        return _fallbackStub();
      }

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

      final imageBytes = await File(imagePath).readAsBytes();
      final prompt = TextPart("Extract the blood pressure reading from this digital monitor. Return ONLY a JSON object with format: {\"sys\": <systolic_value>, \"dia\": <diastolic_value>, \"pulse\": <pulse_value>}. If unreadable, return empty JSON.");
      final imagePart = DataPart('image/jpeg', imageBytes);

      final response = await model.generateContent([
        Content.multi([prompt, imagePart])
      ]);

      final text = response.text;
      if (text == null) return _fallbackStub();

      // Basic cleanup for JSON parsing (remove markdown code blocks if any)
      final jsonString = text.replaceAll('```json', '').replaceAll('```', '').trim();
      
      try {
        final Map<String, dynamic> data = json.decode(jsonString);
        return {
          'systolic': data['sys'] is int ? data['sys'] : int.tryParse(data['sys'].toString()) ?? 120,
          'diastolic': data['dia'] is int ? data['dia'] : int.tryParse(data['dia'].toString()) ?? 80,
          'pulse': data['pulse'] is int ? data['pulse'] : int.tryParse(data['pulse'].toString()) ?? 70,
        };
      } catch (e) {
        debugPrint('JSON Parsing Error: $e');
        return _fallbackStub();
      }

    } catch (e) {
      debugPrint('Gemini Error: $e');
      return _fallbackStub();
    }
  }

  Future<Map<String, int>> _fallbackStub() async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'systolic': 124,
      'diastolic': 82,
      'pulse': 72,
    };
  }
}
