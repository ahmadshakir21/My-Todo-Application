import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screen/authentication/forget_password.dart';

class AuthenticationSignIn extends StatefulWidget {
  const AuthenticationSignIn({Key? key, required this.onClickedSignUp})
      : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  State<AuthenticationSignIn> createState() => _AuthenticationSignInState();
}

class _AuthenticationSignInState extends State<AuthenticationSignIn> {
  late final TextEditingController emailController;

  late final TextEditingController passwordController;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // regular expression to check if string
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  double password_strength = 0;

  // 0: No password
  // 1/4: Weak
  // 2/4: Medium
  // 3/4: Strong
  //   1:   Great

  //A function that validate user entered password
  bool validatePassword(String pass) {
    String _password = pass.trim();

    if (_password.isEmpty) {
      setState(() {
        password_strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        password_strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        password_strength = 2 / 4;
      });
    } else {
      if (pass_valid.hasMatch(_password)) {
        setState(() {
          password_strength = 4 / 4;
        });
        return true;
      } else {
        setState(() {
          password_strength = 3 / 4;
        });
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 45, horizontal: 20),
              child: Text("Welcome",
                  style: TextStyle(
                      color: Color(0xFF0B2E40),
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email_rounded),
                              hintText: "Email"),
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
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter min. 6 characters '
                                  : null,
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              hintText: "Password"),
                        ),
                      ),
                    ),
                  ]),
            ),
            ListTile(
              trailing: TextButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return ForgetPassword();
                        },
                      )),
                  child: const Text(
                    "Forget Password",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: ElevatedButton(
                    onPressed: () async {
                      final isvalid = formKey.currentState!.validate();
                      if (!isvalid) return;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      } on FirebaseAuthException catch (e) {
                        print(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF244395),
                    ),
                    child: const Text("SIGN IN"),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 250,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account?',
                    style:
                        const TextStyle(color: Color(0xFF0B2E40), fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' Sign up',
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignUp,
                          style: const TextStyle(
                              color: Color(0xFF244395),
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
