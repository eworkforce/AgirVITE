import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/models/bp_reading.dart';
import 'data/local/boxes/hive_boxes.dart';
import 'data/local/boxes/hive_boxes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BPReadingImplAdapter());
  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox<BPReading>(HiveBoxes.bpReadings);
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: AgirViteApp(),
    ),
  );
}
