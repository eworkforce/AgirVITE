import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/app.dart';
import 'core/models/bp_reading.dart';
import 'core/models/stroke_center.dart';
import 'core/models/user.dart';
import 'features/guardians/models/guardian.dart';
import 'data/local/boxes/hive_boxes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(BPReadingImplAdapter());
  Hive.registerAdapter(StrokeCenterImplAdapter());
  Hive.registerAdapter(UserProfileImplAdapter());
  Hive.registerAdapter(GuardianAdapter());
  
  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox<UserProfile>(HiveBoxes.user);
  await Hive.openBox<BPReading>(HiveBoxes.bpReadings);
  await Hive.openBox<Guardian>(HiveBoxes.guardians);
  
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
