import 'package:bluesurvey_app/config/router/app_router_notifier.dart';
import 'package:bluesurvey_app/presentation/screens/auth/check_auth_screen.dart';
import 'package:bluesurvey_app/presentation/screens/auth/login_screen.dart';
import 'package:bluesurvey_app/presentation/screens/auth/signup_screen.dart';
import 'package:bluesurvey_app/presentation/screens/survey/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      )
    ],
    redirect: (context, state) {
      // final isGoinTo = state.matchedLocation;
      // final authStatus = goRouterNotifier.authStatus;

      // if (isGoinTo.startsWith('/form/')) {
      //   if (authStatus == AuthStatus.checking ||
      //       authStatus == AuthStatus.notAuthenticated ||
      //       authStatus == AuthStatus.authenticated) {
      //     return isGoinTo;
      //   }
      //   return null;
      // }

      // if (isGoinTo == '/succesfull') {
      //   if (authStatus == AuthStatus.checking ||
      //       authStatus == AuthStatus.notAuthenticated ||
      //       authStatus == AuthStatus.authenticated) {
      //     return isGoinTo;
      //   }
      //   return null;
      // }

      // if (isGoinTo == '/splash' && authStatus == AuthStatus.checking) {
      //   if (isGoinTo.startsWith('/form/')) {
      //     return isGoinTo;
      //   }
      //   return null;
      // }

      // if (authStatus == AuthStatus.notAuthenticated) {
      //   if (isGoinTo == '/signin' || isGoinTo == '/signup') return null;

      //   return '/home';
      // }

      // if (authStatus == AuthStatus.authenticated) {
      //   if (isGoinTo == '/signin' ||
      //       isGoinTo == '/signup' ||
      //       isGoinTo == '/splash' ||
      //       isGoinTo == '/home') {
      //     return '/dashboard';
      //   }
      // }

      // return null;
    },
  );
});
