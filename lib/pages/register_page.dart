// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/helpers/helper_functions.dart';
import 'package:social_app/providers/theme_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends ConsumerState<RegisterPage> {
  // text controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final bool isDarkMode = false;

  bool visible = false;

  // register function
  void register() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure passwords match
    if (_passwordController.text != _confirmPwController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error message to user
      displayMessageToUser("Passwords don't match", context);
    }

    // if passwords do match
    else {
      // try creating the user
      try {
        // create the user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // create a user document and add to firestore
        createUserDocument(userCredential);

        // pop loading circle
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/home_page', (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // create a user document and collect them in firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'id': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'username': _usernameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonIcon = ref.watch(buttonIconProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(darkModeProvider.notifier).toggle();
            },
            icon: Icon(
              buttonIcon,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(height: 25),

              // app name
              const Text(
                'S O C I A L  A P P',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 50),

              // username textfield
              MyTextField(
                hintText: "Enter your username",
                obscureText: false,
                controller: _usernameController,
              ),

              const SizedBox(height: 10),

              // email textfield
              MyTextField(
                hintText: "Enter your email",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 10),

              // password textfield
              MyTextField(
                hintText: "Enter your password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 10),

              // confirm password
              MyTextField(
                hintText: "Confirm your password",
                obscureText: true,
                controller: _confirmPwController,
              ),

              const SizedBox(height: 25),

              // sign in button
              Mybutton(
                onTap: register,
                text: 'Register',
              ),

              const Spacer(),

              // don't have an account? Register here
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
