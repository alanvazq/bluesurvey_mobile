import 'package:bluesurvey_app/config/router/app_router_notifier.dart';
import 'package:bluesurvey_app/presentation/providers/auth/auth_provider.dart';
import 'package:bluesurvey_app/presentation/screens/auth/check_auth_screen.dart';
import 'package:bluesurvey_app/presentation/screens/auth/login_screen.dart';
import 'package:bluesurvey_app/presentation/screens/auth/signup_screen.dart';
import 'package:bluesurvey_app/presentation/screens/survey/home_screen.dart';
import 'package:bluesurvey_app/presentation/screens/survey/survey_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
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
      ),
      GoRoute(
        path: '/survey',
        builder: (context, state) => const SurveyScreen(),
      )
    ],
    redirect: (context, state) {
      final isGoinTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

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

      if (isGoinTo == '/splash' && authStatus == AuthStatus.checking) {
        // if (isGoinTo.startsWith('/form/')) {
        //   return isGoinTo;
        // }
        return null;
      }


      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoinTo == '/login' || isGoinTo == '/signup') return null;
        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoinTo == '/login' ||
            isGoinTo == '/signup' ||
            isGoinTo == '/splash') {
          return '/home';
        }
      }

      return null;
    },
  );
});
