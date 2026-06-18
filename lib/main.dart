import 'package:aidme/services/user_services.dart';
import 'package:aidme/widgets/emergency_toggle_button.dart';
import 'package:aidme/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
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
