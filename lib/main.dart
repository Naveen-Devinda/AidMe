import 'package:aidme/navigator_key.dart';
import 'package:aidme/providers/theme_provider.dart';
import 'package:aidme/services/user_services.dart';
import 'package:aidme/widgets/emergency_toggle_button.dart';
import 'package:aidme/widgets/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aidme/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  try {
    debugPrint("🔥 Firebase Connected Successfully! App Name: ${Firebase.app().name}");
  } catch (e) {
    debugPrint("❌ Firebase Connection Failed! Error: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return FutureBuilder(
      future: UserServices.checkUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          bool hasUserName = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.themeMode,
            builder: (context, child) {
              return Stack(
                children: [
                  child ?? const SizedBox.shrink(),
                  const EmergencyToggleButton(),
                ],
              );
            },
            home: Wrapper(showMainScreen: hasUserName),
          );
        }
      },
    );
  }
}
