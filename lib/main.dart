import 'package:aidme/services/user_services.dart';
import 'package:aidme/widgets/emergency_toggle_button.dart';
import 'package:aidme/widgets/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();

  // Test කරන්න දාන code එක
  try {
    print("⚡ Firebase එක Connect කරන්න හදන්නේ...");
    // Firebase App එකේ නම print කරනවා. වැඩ නම් ' [DEFAULT] ' කියලා වැටෙන්න ඕනේ.
    print("🔥 Firebase සාර්ථකව Connect වුනා! App Name: ${Firebase.app().name}");
  } catch (e) {
    print("❌ Firebase Connect වුනේ නැහැ! Error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserServices.checkUsername(),
      builder: (context, snapshot) {
        //IF SNAPSHOT IS STILL WAITING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          bool hasUserName = snapshot.data ?? false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: "Inter"),
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
