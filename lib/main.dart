import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/simple_bloc_observer.dart';
import 'core/helpers/dependency_injection.dart';
import 'core/helpers/shared_preferences_manager.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';
import 'fruit_hub_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Future.wait([
    SharedPreferencesManager.init(),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
  ]);
  setupServiceLocator();
  runApp(FruitHubDashboard(appRouter: AppRouter()));
}
