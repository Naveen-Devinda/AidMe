import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // method fto store the user name and user email in shared pref
  static Future<void> storeUserDetails(
    String userName,
    String email,
    String password,
    String conPassword,
    BuildContext context,
  ) async {
    try {
      // check username and passowrd are same?
      if (password != conPassword) {
        //show a massage to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password and confirm password do not match")),
        );
        return;
      }

      // if user password and confirm password are same then store user name and email

      // create an instents shared preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      //store the user naem and email
      await pref.setString("username", userName);
      await pref.setString("email", email);

      // show msg for user saved your data
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User details Saved Successful")));
    } catch (err) {
      // show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving user details: ${err.toString()}")),
      );
    }
  }

  //method for check weather the username is saved in the shared pref
  static Future<bool> checkUsername() async {
    //create an instrance for shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("username");
    return userName != null;
  }
}
