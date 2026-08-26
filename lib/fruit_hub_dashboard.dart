import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/user_info_cubit/user_info_cubit.dart';
import 'package:toastification/toastification.dart';
import 'core/helpers/di.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_theme.dart';
import 'core/theming/app_theme_cubit.dart';

class FruitHubDashboard extends StatelessWidget {
  const FruitHubDashboard({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider<AppThemeCubit>.value(value: getIt<AppThemeCubit>()),
      BlocProvider<UserInfoCubit>.value(value: getIt<UserInfoCubit>()),
    ],
    child: BlocBuilder<AppThemeCubit, ThemeMode>(
      builder: (context, themeMode) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: Routes.splashView,
          ),
        ),
      ),
    ),
  );
}
