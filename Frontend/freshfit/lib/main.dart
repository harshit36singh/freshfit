import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshfit/features/calendar/calendar_controller.dart';
import 'package:freshfit/features/outfit/outfit_controller.dart';
import 'package:freshfit/features/wardrobe/wardrobe_controller.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/auth/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
           ChangeNotifierProvider(create: (_) => WardrobeController()),
        ChangeNotifierProvider(create: (_) => OutfitController()),
        ChangeNotifierProvider(create: (_) => CalendarController()),
      ],
      child: const MyApp(),
    ),
  );
}