import 'package:fruit_hub_dashboard/core/services/database/firestore_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/storage_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage/supabase_service.dart';
import 'package:fruit_hub_dashboard/features/product/data/firebase/product_firebase.dart';
import 'package:fruit_hub_dashboard/features/product/data/repo_imp/data_sources/remote/product_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/product/data/repo_imp/repo/product_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/product/data/supabase/product_supabase.dart';
import 'package:fruit_hub_dashboard/features/product/domain/use_cases/add_product_use_case.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/firebase/auth_firebase.dart';
import '../../features/auth/data/repo_imp/data_sources/remote/auth_remote_data_source_imp.dart';
import '../../features/auth/data/repo_imp/repo/auth_repo_imp.dart';
import '../../features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import '../../features/auth/domain/use_cases/forget_password_use_case.dart';
import '../../features/auth/domain/use_cases/google_sign_in_use_case.dart';
import '../../features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import '../services/database/database_service.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<StorageService>(SupabaseService());

  getIt.registerSingleton<ProductRepoImp>(
    ProductRepoImp(
      ProductRemoteDataSourceImp(
        ProductSupabase(getIt.get<StorageService>()),
        ProductFirebase(getIt.get<DatabaseService>()),
        getIt.get<DatabaseService>(),
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
        AuthFirebase.instance,
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
