import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<UserCredential> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await credential.user?.updateDisplayName(name.trim());
    return credential;
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  static Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('email');
    await prefs.remove('gender');
    await prefs.remove('dob');
    await prefs.remove('phone');
    await prefs.remove('bloodGroup');
    await prefs.remove('height');
    await prefs.remove('weight');
    await prefs.remove('chronicDiseases');
    await prefs.remove('emergencyContact1Name');
    await prefs.remove('emergencyContact1Phone');
    await prefs.remove('emergencyContact2Name');
    await prefs.remove('emergencyContact2Phone');
    await prefs.remove('emergencyContact3Name');
    await prefs.remove('emergencyContact3Phone');

    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  static String friendlyAuthError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Email or password is incorrect.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'network-request-failed':
          return 'Please check your internet connection.';
        default:
          return error.message ?? 'Authentication failed. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }

  // method to store the user details in shared pref
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User details Saved Successful")),
        );
      }
    } catch (err) {
      // show error message to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving user details: ${err.toString()}"),
          ),
        );
      }
    }
  }

  //method for check weather the username is saved in the shared pref
  static Future<bool> checkUsername() async {
    //create an instrance for shared pref
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("username");
    return userName != null || _auth.currentUser != null;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserProfile() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  static Future<void> saveProfileToLocal(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', data['name'] ?? '');
    await prefs.setString('email', data['email'] ?? '');
    await prefs.setString('gender', data['gender'] ?? '');
    await prefs.setString('dob', data['dob'] ?? '');
    await prefs.setString('phone', data['phone'] ?? '');
    await prefs.setString('bloodGroup', data['bloodGroup'] ?? '');
    await prefs.setString('height', data['height'] ?? '');
    await prefs.setString('weight', data['weight'] ?? '');
    await prefs.setStringList(
      'chronicDiseases',
      (data['chronicDiseases'] as List?)?.cast<String>() ?? [],
    );
    final contacts = (data['emergencyContacts'] as List?) ?? [];
    for (var i = 0; i < 3; i++) {
      final c = i < contacts.length ? contacts[i] as Map? : null;
      await prefs.setString('emergencyContact${i + 1}Name', c?['name'] ?? '');
      await prefs.setString('emergencyContact${i + 1}Phone', c?['phone'] ?? '');
    }
  }

  static Future<void> updateProfileInFirestore(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
    }
  }

  static Future<void> changePassword(String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  static Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    await _firestore.collection('users').doc(user.uid).delete();
    await user.delete();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<void> storeRegistrationProfile({
    required String name,
    required String email,
    required String gender,
    required String dob,
    required String phone,
    required String bloodGroup,
    required String height,
    required String weight,
    required List<String> chronicDiseases,
    required List<Map<String, String>> emergencyContacts,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'gender': gender,
        'dob': dob,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'height': height,
        'weight': weight,
        'chronicDiseases': chronicDiseases,
        'emergencyContacts': emergencyContacts,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);
    await prefs.setString('email', email);
    await prefs.setString('gender', gender);
    await prefs.setString('dob', dob);
    await prefs.setString('phone', phone);
    await prefs.setString('bloodGroup', bloodGroup);
    await prefs.setString('height', height);
    await prefs.setString('weight', weight);
    await prefs.setStringList('chronicDiseases', chronicDiseases);

    for (var i = 0; i < emergencyContacts.length; i++) {
      await prefs.setString(
        'emergencyContact${i + 1}Name',
        emergencyContacts[i]['name'] ?? '',
      );
      await prefs.setString(
        'emergencyContact${i + 1}Phone',
        emergencyContacts[i]['phone'] ?? '',
      );
    }
  }
}
