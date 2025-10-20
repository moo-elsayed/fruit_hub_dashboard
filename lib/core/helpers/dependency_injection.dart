import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_hub_dashboard/core/services/authentication/auth_service.dart';
import 'package:fruit_hub_dashboard/features/shared_data/services/database/firestore_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/features/shared_data/services/storage/supabase_service.dart';
import 'package:fruit_hub_dashboard/features/product/data/repo_imp/product_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/product/domain/use_cases/add_product_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import '../../features/auth/data/repo_imp/auth_repo_imp.dart';
import '../../features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import '../../features/auth/domain/use_cases/forget_password_use_case.dart';
import '../../features/auth/domain/use_cases/google_sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import '../../features/product/data/data_sources/remote/product_remote_data_source_imp.dart';
import '../../features/shared_data/services/authentication/firebase_auth_service.dart';
import '../services/database/database_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<AuthService>(
    FirebaseAuthService(FirebaseAuth.instance, GoogleSignIn.instance),
  );

  getIt.registerSingleton<DatabaseService>(
    FirestoreService(FirebaseFirestore.instance),
  );
  getIt.registerSingleton<StorageService>(
    SupabaseService(Supabase.instance.client),
  );

  getIt.registerSingleton<ProductRepoImp>(
    ProductRepoImp(
      ProductRemoteDataSourceImp(
        getIt.get<DatabaseService>(),
        getIt.get<StorageService>(),
      ),
    ),
  );

  getIt.registerSingleton<AddProductUseCase>(
    AddProductUseCase(getIt.get<ProductRepoImp>()),
  );

  /// auth
  getIt.registerSingleton<AuthRepoImp>(
    AuthRepoImp(
      AuthRemoteDataSourceImp(
        getIt.get<AuthService>(),
        getIt.get<DatabaseService>(),
      ),
    ),
  );

  getIt.registerSingleton<SignInWithEmailAndPasswordUseCase>(
    SignInWithEmailAndPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerSingleton<CreateUserWithEmailAndPasswordUseCase>(
    CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerSingleton<GoogleSignInUseCase>(
    GoogleSignInUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerSingleton<ForgetPasswordUseCase>(
    ForgetPasswordUseCase(getIt<AuthRepoImp>()),
  );
}
