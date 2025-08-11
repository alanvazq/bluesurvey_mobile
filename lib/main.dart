import 'package:bluesurvey_app/config/constants/environment.dart';
import 'package:bluesurvey_app/config/router/app_router.dart';
import 'package:bluesurvey_app/config/themes/dark_theme.dart';
import 'package:bluesurvey_app/config/themes/light_theme.dart';
import 'package:bluesurvey_app/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await Environment.initEnvirontment();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? darkTheme : lightTheme,
    );
  }
}
