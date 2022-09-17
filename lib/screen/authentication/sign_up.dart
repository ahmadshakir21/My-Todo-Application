import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/model/user.dart';

class AuthenticationSignUp extends StatefulWidget {
  const AuthenticationSignUp({Key? key, required this.onClickedSignIn})
      : super(key: key);

  final VoidCallback onClickedSignIn;

  @override
  State<AuthenticationSignUp> createState() => _AuthenticationSignUpState();
}

class _AuthenticationSignUpState extends State<AuthenticationSignUp> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future signUp() async {
    final isvalid = formKey.currentState!.validate();
    if (!isvalid) return;
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) => sendInfoForCloudFirestore());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  sendInfoForCloudFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    UserModel userModel = UserModel();
    userModel.uID = user?.uid;
    userModel.name = userNameController.text;
    userModel.email = user?.email;
    userModel.image = "";

    await firebaseFirestore
        .collection('user')
        .doc(user?.uid)
        .set(userModel.toMap());
    // UserModel userModel = UserModel();

    // userModel.uID = user?.uid;
    // userModel.name = userNameController.text;
    // userModel.email = user?.email;
    // userModel.phoneNumber = int.parse(phoneNumberController.text);

    // await firebaseFirestore
    //     .collection("user")
    //     .doc(user?.uid)
    //     .set(userModel.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 15),
                child: Text(
                  "Create Your Account",
                  style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0B2E40)),
                )),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Please Enter Your Credentials in the Form Below..!",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7E7B7B)),
                )),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{5,}$');
                          if (value!.isEmpty) {
                            return ("Username cannot be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid name(Min. 5 Character)");
                          }
                          return null;
                        },
                        controller: userNameController,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: "Username",
                          hintStyle: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        controller: emailController,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.alternate_email_rounded),
                            hintText: "Email",
                            hintStyle: GoogleFonts.poppins()),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter min. 6 characters '
                            : null,
                        controller: passwordController,
                        style: GoogleFonts.poppins(),
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            hintText: "Password",
                            hintStyle: GoogleFonts.poppins()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 75,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ElevatedButton(
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF0B2E40),
                    ),
                    child: Text(
                      "SIGN UP",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 135,
            ),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: 'Already have an Account?',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF0B2E40)),
                      children: <TextSpan>[
                    TextSpan(
                      text: ' Sign in',
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue),
                    )
                  ])),
            )
          ]))),
    );
  }
}
