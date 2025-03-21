import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/providers/auth/signup_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SignUpView(),
    );
  }
}

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Crea tu cuenta",
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
                TextSpan(
                  text: ".",
                  style: TextStyle(
                    fontSize: 54,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SignUpFormView(),
        ],
      ),
    );
  }
}

class SignUpFormView extends ConsumerWidget {
  const SignUpFormView({super.key});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final signupState = ref.watch(signupProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
      if (next.authStatus == AuthStatus.newUser) {
        context.push("/login");
      }
    });

    return Column(
      children: [
        CustomTextField(
          label: "Nombre",
          onChanged: ref.read(signupProvider.notifier).onNameChanged,
          errorMessage:
              signupState.isFormPosted ? signupState.name.errorMessage : null,
        ),
        SizedBox(
          height: 10,
        ),
        CustomTextField(
          label: "Correo",
          onChanged: ref.read(signupProvider.notifier).onEmailChanged,
          errorMessage:
              signupState.isFormPosted ? signupState.email.errorMessage : null,
        ),
        SizedBox(
          height: 10,
        ),
        CustomTextField(
          label: "Contraseña",
          onChanged: ref.read(signupProvider.notifier).onPasswordChanged,
          errorMessage: signupState.isFormPosted
              ? signupState.password.errorMessage
              : null,
          isObscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: signupState.isPosting
                  ? null
                  : () {
                      ref.read(signupProvider.notifier).onFormSubmit();
                    },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                "Registrarme",
                style: TextStyle(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            )),
        SizedBox(
          height: 10,
        ),
        TextButton(
            onPressed: () {
              context.push('/login');
            },
            child: Text(
              "Ya tengo cuenta",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
