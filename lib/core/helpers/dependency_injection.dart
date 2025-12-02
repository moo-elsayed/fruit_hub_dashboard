import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fruit_hub_dashboard/core/helpers/image_compressor.dart';
import 'package:fruit_hub_dashboard/core/services/authentication/auth_service.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/shared_data/services/database/firestore_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/features/shared_data/services/storage/supabase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import '../../features/auth/data/repo_imp/auth_repo_imp.dart';
import '../../features/auth/domain/use_cases/clear_user_session_use_case.dart';
import '../../features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import '../../features/auth/domain/use_cases/forget_password_use_case.dart';
import '../../features/auth/domain/use_cases/google_sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/save_user_session_use_case.dart';
import '../../features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import '../../features/auth/domain/use_cases/sign_out_use_case.dart';
import '../../features/products/data/data_sources/remote/products_remote_data_source_imp.dart';
import '../../features/products/data/repo_imp/products_repo_imp.dart';
import '../../features/products/domain/use_cases/add_product_use_case.dart';
import '../../features/products/domain/use_cases/delete_product_use_case.dart';
import '../../features/products/domain/use_cases/get_products_use_case.dart';
import '../../features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import '../../features/shared_data/services/authentication/firebase_auth_service.dart';
import '../../features/shared_data/services/local_storage/shared_preferences_manager.dart';
import '../services/database/database_service.dart';
import '../services/local_storage/local_storage_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingletonAsync<LocalStorageService>(() async {
    final service = SharedPreferencesManager();
    await service.init();
    return service;
  });

  getIt.registerSingleton<AuthService>(
    FirebaseAuthService(FirebaseAuth.instance, GoogleSignIn.instance),
  );

  getIt.registerSingleton<DatabaseService>(
    FirestoreService(FirebaseFirestore.instance),
  );

  getIt.registerSingleton<ImageCompressor>(ImageCompressor());

  getIt.registerSingleton<StorageService>(
    SupabaseService(Supabase.instance.client, getIt.get<ImageCompressor>()),
  );

  getIt.registerSingleton<SignOutService>(
    FirebaseAuthService(FirebaseAuth.instance, GoogleSignIn.instance),
  );

  /// auth
  getIt.registerSingleton<AuthRepoImp>(
    AuthRepoImp(
      AuthRemoteDataSourceImp(
        getIt.get<AuthService>(),
        getIt.get<DatabaseService>(),
        getIt.get<SignOutService>(),
      ),
    ),
  );

  getIt.registerLazySingleton<SaveUserSessionUseCase>(
    () => SaveUserSessionUseCase(getIt<LocalStorageService>()),
  );

  getIt.registerLazySingleton<ClearUserSessionUseCase>(
    () => ClearUserSessionUseCase(getIt<LocalStorageService>()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(
      getIt<AuthRepoImp>(),
      getIt.get<ClearUserSessionUseCase>(),
    ),
  );

  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(
      getIt<AuthRepoImp>(),
      getIt.get<SaveUserSessionUseCase>(),
    ),
  );

  getIt.registerSingleton<CreateUserWithEmailAndPasswordUseCase>(
    CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(
      getIt<AuthRepoImp>(),
      getIt.get<SaveUserSessionUseCase>(),
    ),
  );

  getIt.registerSingleton<ForgetPasswordUseCase>(
    ForgetPasswordUseCase(getIt<AuthRepoImp>()),
  );

  /// products
  getIt.registerSingleton<ProductsRepoImp>(
    ProductsRepoImp(
      ProductsRemoteDataSourceImp(
        getIt.get<DatabaseService>(),
        getIt.get<StorageService>(),
      ),
    ),
  );

  getIt.registerSingleton<GetProductsUseCase>(
    GetProductsUseCase(getIt.get<ProductsRepoImp>()),
  );
  getIt.registerSingleton<AddProductUseCase>(
    AddProductUseCase(getIt.get<ProductsRepoImp>()),
  );
  getIt.registerSingleton<DeleteProductUseCase>(
    DeleteProductUseCase(getIt.get<ProductsRepoImp>()),
  );
  getIt.registerSingleton<UpdateProductUseCase>(
    UpdateProductUseCase(getIt.get<ProductsRepoImp>()),
  );

  /// settings
  getIt.registerSingleton<SettingsRepoImp>(
    SettingsRepoImp(SettingsRemoteDataSourceImp(getIt.get<DatabaseService>())),
  );

  getIt.registerSingleton<UpdateShippingConfigUseCase>(
    UpdateShippingConfigUseCase(getIt.get<SettingsRepoImp>()),
  );

  getIt.registerSingleton<FetchShippingConfigUseCase>(
    FetchShippingConfigUseCase(getIt.get<SettingsRepoImp>()),
  );
}
