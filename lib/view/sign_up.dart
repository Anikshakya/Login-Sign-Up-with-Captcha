// ignore_for_file: prefer_const_constructors

import 'package:captcha_app/utils/utils.dart';
import 'package:captcha_app/view/home.dart';
import 'package:captcha_app/widgets/shapes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

  final GlobalKey<ScaffoldState> _messangerKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText2 = true;
  final formKey = GlobalKey<FormState>();
  //-----Sign up validation-----
  signUpValidation() {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: 450,
                child: WebViewPlus(
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (controller) {
                    controller.loadUrl("webpages/index.html");
                  },
                  javascriptChannels: {
                    JavascriptChannel(
                        name: 'Captcha',
                        onMessageReceived: (JavascriptMessage message) {
                          signUp();
                        })
                  },
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
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
              key: _messangerKey,
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
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              iconSize: 30,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "To create an new account sign up below",
                              style: TextStyle(),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(232, 186, 187, 187),
                                  offset: Offset(1, 8),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 40, bottom: 50),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (name) => name!.isEmpty
                                        ? "Name field cannot be empty."
                                        : null,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.next,
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        size: 18,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      iconColor: Colors.teal,
                                      hintText: 'Enter your Name',
                                      labelText: 'Full Name',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) => email != null &&
                                            !EmailValidator.validate(email)
                                        ? "Enter a valid email"
                                        : null,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        size: 18,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      iconColor: Colors.teal,
                                      hintText: 'Enter your Email',
                                      labelText: 'Email',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (contact) => contact!.isEmpty
                                        ? "Contact cannot be empty."
                                        : null,
                                    keyboardType: TextInputType.phone,
                                    textInputAction: TextInputAction.next,
                                    controller: contactController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        size: 18,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      iconColor: Colors.teal,
                                      hintText: 'Enter your Contact',
                                      labelText: 'Contact',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: passwordController,
                                    textInputAction: TextInputAction.next,
                                    obscureText: _obscureText,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => value != null &&
                                            !regex.hasMatch(value)
                                        ? "Enter min 8 characters with at least 1 Uppercase, \n1 Special character, 1 number."
                                        : null,
                                    decoration: InputDecoration(
                                      suffix: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              _obscureText = !_obscureText;
                                            },
                                          );
                                        },
                                        child: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 18,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintText: 'Enter your Password',
                                      labelText: 'Password',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    obscureText: _obscureText2,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => value != null &&
                                            value != passwordController.text
                                        ? "Password does not match"
                                        : null,
                                    decoration: InputDecoration(
                                      suffix: GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              _obscureText2 = !_obscureText2;
                                            },
                                          );
                                        },
                                        child: Icon(
                                          _obscureText2
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        size: 18,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      hintText: 'Re-Enter your Password',
                                      labelText: 'Confirm Password',
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                      labelStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 102, 102, 102),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: signUpValidation,
                                      child: const Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                                  ),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text("By sigining up you accept our"),
                                        Text(
                                          "Terms of Services and Privacy Policy",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                          // maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      //sends email and passeord to firebase auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );
      //sends name phone passoword and email to firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(emailController.text.trim())
          .set(
            {
              'email': emailController.text.trim().toLowerCase(),
              'name': nameController.text.trim(),
              'contact': contactController.text.trim(),
            },
          )
          .then((value) => Utils.showSnackBar("Sign up successful!", true))
          .then((value) => Navigator.pop(context))
          .then((value) => Navigator.pop(context));
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message.toString(), false);
      Navigator.pop(context);
      navigatorKey.currentState!.popUntil((route) => route.isActive);
    }

    navigatorKey.currentState!.popUntil((route) => route.isActive);
  }
}
