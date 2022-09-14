import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailForForgetPasswordController = TextEditingController();

  @override
  void dispose() {
    emailForForgetPasswordController.dispose();
    super.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailForForgetPasswordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF3F6F9),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 30,
                        color: Color(0xFF0B2E40),
                      )),
                  const SizedBox(
                    width: 65,
                  ),
                  const Text(
                    "Forget Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B2E40),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 225,
              ),
              const Text(
                "Enter your email then click at reset password then change your password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0B2E40),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailForForgetPasswordController,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.alternate_email_rounded),
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: 250,
                height: 40,
                child: ElevatedButton(
                    onPressed: resetPassword,
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF244395)),
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ]))));
  }
}
