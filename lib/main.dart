import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/simple_bloc_observer.dart';

import 'package:google_sign_in/google_sign_in.dart';

import 'core/helpers/backend_endpoints.dart';
import 'core/helpers/di.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';
import 'fruit_hub_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    GoogleSignIn.instance.initialize(
      serverClientId: BackendEndpoints.googleServerClientId,
    ),
  ]);

  setupServiceLocator();
  await getIt.allReady();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      saveLocale: true,
      startLocale: const Locale('ar'),
      child: FruitHubDashboard(appRouter: AppRouter()),
    ),
  );
}
