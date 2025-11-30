import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/env.dart';
import 'package:fruit_hub_dashboard/simple_bloc_observer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/helpers/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'firebase_options.dart';
import 'fruit_hub_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey),
  ]);
  setupServiceLocator();
  await getIt.allReady();
  runApp(FruitHubDashboard(appRouter: AppRouter()));
}
