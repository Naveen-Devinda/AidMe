import 'package:aidme/pages/home_page.dart';
import 'package:aidme/services/user_services.dart';
import 'package:aidme/widgets/custombutton.dart';
import 'package:flutter/material.dart';

class CreateAcc extends StatefulWidget {
  const CreateAcc({super.key});

  @override
  State<CreateAcc> createState() => _CreateAccState();
}

class _CreateAccState extends State<CreateAcc> {
  //form key for the form validation
  final formKey = GlobalKey<FormState>();

  //controller for the text from feilds
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conPasswordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    conPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Account",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Personal Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),

                SizedBox(height: 20),

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      // form feild for the user name
                      TextFormField(
                        controller: userNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height: 10),

                      // form feild for the email
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your email";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height: 10),

                      //form feild for password
                      TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your Password";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      SizedBox(height: 10),

                      // feild for confirm password
                      TextFormField(
                        controller: conPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your Same password";
                          }
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            //form is valid
                            String username = userNameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String conPassword = conPasswordController.text;

                            await UserServices.storeUserDetails(
                              username,
                              email,
                              password,
                              conPassword,
                              context,
                            );

                            //navigate home page
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const HomePage();
                                  },
                                ),
                              );
                            }
                          }
                        },

                        // save the user name and email in device storage
                        child: Custombutton(
                          buttonName: "Next",
                          buttonColor: Color(0xff3FBBBB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
