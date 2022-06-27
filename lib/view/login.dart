import 'package:captcha_app/utils/utils.dart';
import 'package:captcha_app/view/forgot_password.dart';
import 'package:captcha_app/view/home.dart';
import 'package:captcha_app/view/sign_up.dart';
import 'package:captcha_app/widgets/shapes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final navigatorKey = GlobalKey<NavigatorState>();
  bool _obscureText = true;
  //-----Email & password editing value contoller-----
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //---Validator key----
  final formKey = GlobalKey<FormState>();
  final successKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (conext) {
            return AlertDialog(
              title: const Text("Do you want to quit?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('This will exit the app.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );

        return true;
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong"),
              );
            } else if (snapshot.hasData) {
              return const Home();
            } else {
              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 221, 221, 221),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        ClipPath(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 174, 22, 121),
                                  Color.fromARGB(255, 255, 70, 191),
                                ],
                              ),
                            ),
                          ),
                          clipper: CustomClipperCurve(),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                IconButton(
                                  iconSize: 32,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (conext) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Do you want to quit?"),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text('This will exit the app.'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Yes'),
                                              onPressed: () {
                                                SystemNavigator.pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.output_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 55,
                            ),
                            GestureDetector(
                              onDoubleTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              },
                              child: const Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(45),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(232, 186, 187, 187),
                                    offset: Offset(2, 8),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 40, bottom: 50),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: emailController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? "Enter a valid email"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.email,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        // hintText: 'Enter your username',
                                        labelText: 'Email',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 102, 102),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      obscureText: _obscureText,
                                      controller: passwordController,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.isEmpty
                                              ? "Password cannot be empty"
                                              : null,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 20,
                                          color: Colors.grey,
                                        ),

                                        suffix: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        // hintText: 'Enter your username',
                                        labelText: 'Password',
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 102, 102, 102),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      onPressed: logIn,
                                      child: const Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontSize: 15.8,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          fixedSize: const Size(350, 45),
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                          primary: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          onPrimary: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassword()),
                                      ),
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an Account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Create an Account",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  //-----Login method for firebase-----
  Future logIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
          .then((value) => Utils.showSnackBar("Logged in successfully", true))
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message.toString(), false);
    }

    //----Navigator.of(context) not working-----
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
