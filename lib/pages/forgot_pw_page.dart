import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/providers/theme_provider.dart';

class ForgotPWPage extends ConsumerWidget {
  ForgotPWPage({super.key});

  // text controllers
  final _emailController = TextEditingController();

  // forgot pw button
  void forgotPW() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonIcon = ref.watch(buttonIconProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // email textfield
            MyTextField(
              hintText: "Enter your email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 25),

            // forgot button
            Mybutton(
              onTap: forgotPW,
              text: 'Reset Password',
            ),
          ],
        ),
      ),
    );
  }
}
