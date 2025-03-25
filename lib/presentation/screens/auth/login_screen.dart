import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/providers/auth/login_provider.dart';
import 'package:bluesurvey_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
                  text: "Ingresa tus datos",
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
          FormLoginView(),
        ],
      ),
    );
  }
}

class FormLoginView extends ConsumerWidget {
  const FormLoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final loginState = ref.watch(loginProvider);
    return Column(
      children: [
        CustomTextField(
          label: "Correo",
          onChanged: ref.read(loginProvider.notifier).onEmailChanged,
          errorMessage:
              loginState.isFormPosted ? loginState.email.errorMessage : null,
        ),
        SizedBox(
          height: 10,
        ),
        CustomTextField(
          label: "Contraseña",
          onChanged: ref.read(loginProvider.notifier).onPasswordChanged,
          errorMessage:
              loginState.isFormPosted ? loginState.password.errorMessage : null,
              isObscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(loginProvider.notifier).onFormSubmit();
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                "Iniciar sesión",
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
              context.push('/signup');
            },
            child: Text(
              "No tengo cuenta",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
