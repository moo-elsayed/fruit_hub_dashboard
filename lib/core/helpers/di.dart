import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/core/theming/app_theme_cubit.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/data_sources/remote/analytics_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/repo_imp/analytics_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/repo/analytics_repo.dart';
import 'package:fruit_hub_dashboard/features/analytics/domain/use_cases/get_analytics_use_case.dart';
import 'package:fruit_hub_dashboard/features/analytics/presentation/managers/analytics_cubit/analytics_cubit.dart';
import 'package:fruit_hub_dashboard/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/auth/data/repo_imp/auth_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/repo/auth_repo.dart';
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
import 'package:fruit_hub_dashboard/features/orders/presentation/managers/orders_cubit/orders_cubit.dart';
import 'package:fruit_hub_dashboard/features/products/data/data_sources/remote/products_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/products/data/repo_imp/products_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/products/domain/repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/domain/use_cases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/managers/products_cubit/products_cubit.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/data/repo_imp/settings_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/settings_repo/settings_repo.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/fetch_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/use_cases/update_shipping_config_use_case.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/managers/settings_cubit/settings_cubit.dart';
import 'package:fruit_hub_dashboard/features/splash/presentation/managers/splash_cubit/splash_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/data/data_sources/remote/users_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/users/data/repo_imp/users_repo_imp.dart';
import 'package:fruit_hub_dashboard/features/users/domain/repo/users_repo.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_user_notifications_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_stats_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/get_users_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/search_users_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/domain/use_cases/send_user_notification_use_case.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/user_notifications_cubit/user_notifications_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_cubit/users_cubit.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/managers/users_search_cubit/users_search_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/app_language_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingletonAsync<AppPreferencesService>(() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return AppPreferencesServiceImpl(sharedPreferences);
  });

  getIt.registerLazySingleton<AppThemeCubit>(
    () => AppThemeCubit(getIt<AppPreferencesService>()),
  );

  getIt.registerLazySingleton<AppLanguageCubit>(
    () => AppLanguageCubit(getIt<AppPreferencesService>()),
  );

  getIt.registerLazySingleton<UserInfoCubit>(
    () => UserInfoCubit(
      getIt<AppPreferencesService>(),
      getIt<GetUserInfoUseCase>(),
    ),
  );

  /// auth
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImp(AuthRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<SignInWithEmailAndPasswordUseCase>(
    () => SignInWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<CreateUserWithEmailAndPasswordUseCase>(
    () => CreateUserWithEmailAndPasswordUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<GoogleSignInUseCase>(
    () => GoogleSignInUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<ForgetPasswordUseCase>(
    () => ForgetPasswordUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<GetUserInfoUseCase>(
    () => GetUserInfoUseCase(getIt<AuthRepo>()),
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

  /// splash
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<AppPreferencesService>()),
  );

  /// products
  getIt.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImp(ProductsRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductsRepo>()),
  );
  getIt.registerLazySingleton<AddProductUseCase>(
    () => AddProductUseCase(getIt<ProductsRepo>()),
  );
  getIt.registerLazySingleton<DeleteProductUseCase>(
    () => DeleteProductUseCase(getIt<ProductsRepo>()),
  );
  getIt.registerLazySingleton<UpdateProductUseCase>(
    () => UpdateProductUseCase(getIt<ProductsRepo>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getIt<AddProductUseCase>(),
      getIt<GetProductsUseCase>(),
      getIt<DeleteProductUseCase>(),
      getIt<UpdateProductUseCase>(),
    ),
  );

  /// settings
  getIt.registerLazySingleton<SettingsRepo>(
    () => SettingsRepoImp(SettingsRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<UpdateShippingConfigUseCase>(
    () => UpdateShippingConfigUseCase(getIt<SettingsRepo>()),
  );

  getIt.registerLazySingleton<FetchShippingConfigUseCase>(
    () => FetchShippingConfigUseCase(getIt<SettingsRepo>()),
  );

  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(
      getIt<FetchShippingConfigUseCase>(),
      getIt<UpdateShippingConfigUseCase>(),
    ),
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

  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(
      getIt<GetOrdersUseCase>(),
      getIt<UpdateOrderStatusUseCase>(),
    ),
  );

  /// analytics
  getIt.registerLazySingleton<AnalyticsRepo>(
    () => AnalyticsRepoImp(AnalyticsRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<GetAnalyticsUseCase>(
    () => GetAnalyticsUseCase(getIt<AnalyticsRepo>()),
  );

  getIt.registerFactory<AnalyticsCubit>(
    () => AnalyticsCubit(getIt<GetAnalyticsUseCase>()),
  );

  /// users
  getIt.registerLazySingleton<UsersRepo>(
    () => UsersRepoImp(UsersRemoteDataSourceImp()),
  );

  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UsersRepo>()),
  );

  getIt.registerLazySingleton<GetUsersStatsUseCase>(
    () => GetUsersStatsUseCase(getIt<UsersRepo>()),
  );

  getIt.registerLazySingleton<GetUserNotificationsUseCase>(
    () => GetUserNotificationsUseCase(getIt<UsersRepo>()),
  );

  getIt.registerLazySingleton<SearchUsersUseCase>(
    () => SearchUsersUseCase(getIt<UsersRepo>()),
  );

  getIt.registerLazySingleton<SendUserNotificationUseCase>(
    () => SendUserNotificationUseCase(getIt<UsersRepo>()),
  );

  getIt.registerFactory<UsersCubit>(
    () => UsersCubit(getIt<GetUsersUseCase>(), getIt<GetUsersStatsUseCase>()),
  );

  getIt.registerFactory<UsersSearchCubit>(
    () => UsersSearchCubit(getIt<SearchUsersUseCase>()),
  );

  getIt.registerFactory<UserNotificationsCubit>(
    () => UserNotificationsCubit(
      getIt<GetUserNotificationsUseCase>(),
      getIt<SendUserNotificationUseCase>(),
    ),
  );
}
