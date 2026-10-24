import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app/app.dart';
import 'core/models/stroke_center.dart';
import 'core/models/user.dart';
import 'features/guardians/models/guardian.dart';
import 'data/local/boxes/hive_boxes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Disable runtime HTTP font fetching (100% offline-first with bundled assets/fonts/)
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize Hive (100% local persistence)
  await Hive.initFlutter();
  Hive.registerAdapter(StrokeCenterImplAdapter());
  Hive.registerAdapter(UserProfileImplAdapter());
  Hive.registerAdapter(GuardianAdapter());

  await Hive.openBox(HiveBoxes.settings);
  await Hive.openBox<UserProfile>(HiveBoxes.user);
  await Hive.openBox<Guardian>(HiveBoxes.guardians);

  runApp(
    const ProviderScope(
      child: AgirViteApp(),
    ),
  );
}
