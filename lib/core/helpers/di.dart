import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/create_user_with_email_and_password_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/forget_password_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/get_user_info_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/google_sign_in_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/sign_in_with_email_and_password_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/forget_password_cubit/forget_password_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signin_cubit/sign_in_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signup_cubit/sign_up_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/social_sign_in_cubit/social_sign_in_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/user_info_cubit/user_info_cubit.dart';
import 'package:fruit_hub_dashboard/features/orders/data/data_sources/remote/orders_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/data/repo_imp/orders_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repo/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/get_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/use_cases/update_order_status_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/products/data/repo_imp/products_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingletonAsync<AppPreferencesService>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return AppPreferencesServiceImpl(sharedPreferences);
  });

  getIt.registerLazySingleton<AppThemeCubit>(
    () => AppThemeCubit(getIt<AppPreferencesService>()),
  );

  getIt.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(
      getIt<AppPreferencesService>(),
      getIt<GetUserInfoUseCase>(),
    ),
  );

  /// auth
  getIt.registerLazySingleton<AuthRepoImp>(
    () => AuthRepoImp(AuthRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<CreateUserWithEmailAndPasswordUseCase>(
    () => CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<ForgetPasswordUseCase>(
    () => ForgetPasswordUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(getIt<AuthRepoImp>()),
  );

  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(getIt<SignInWithEmailAndPasswordUseCase>()),
  );

  getIt.registerFactory<SocialSignInCubit>(
    () => SocialSignInCubit(getIt<GoogleSignInUseCase>()),
  );

  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<CreateUserWithEmailAndPasswordUseCase>()),
  );

  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(getIt<ForgetPasswordUseCase>()),
  );

  getIt.registerFactory<SignOutCubit>(
    () => SignOutCubit(getIt<SignOutUseCase>()),
  );

  /// products
  getIt.registerLazySingleton<ProductsRepoImp>(
    () => ProductsRepoImp(ProductsRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductsRepoImp>()),
  );
  getIt.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCase(getIt<ProductsRepoImp>()),
  );
  getIt.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(getIt<ProductsRepoImp>()),
  );
  getIt.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(getIt<ProductsRepoImp>()),
  );

  /// settings
  getIt.registerLazySingleton<SettingsRepoImp>(
    () => SettingsRepoImp(SettingsRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<UpdateShippingConfigUseCase>(
    () => UpdateShippingConfigUseCase(getIt<SettingsRepoImp>()),
  );

  getIt.registerLazySingleton<FetchShippingConfigUseCase>(
    () => FetchShippingConfigUseCase(getIt<SettingsRepoImp>()),
  );

  /// orders
  getIt.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImp(OrdersRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<GetOrdersUseCase>(
    () => GetOrdersUseCase(getIt<OrdersRepo>()),
  );

  getIt.registerLazySingleton<UpdateOrderStatusUseCase>(
    () => UpdateOrderStatusUseCase(getIt<OrdersRepo>()),
  );
}
