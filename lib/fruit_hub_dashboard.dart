import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/helpers/dependency_injection.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_colors.dart';
import 'features/products/domain/use_cases/add_product_use_case.dart';
import 'features/products/domain/use_cases/get_products_use_case.dart';
import 'features/products/presentation/managers/products_cubit/products_cubit.dart';

class FruitHubDashboard extends StatelessWidget {
  const FruitHubDashboard({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider(
        create: (context) => ProductsCubit(
          getIt.get<AddProductUseCase>(),
          getIt.get<GetProductsUseCase>(),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
            ),
          ),
          onGenerateRoute: appRouter.generateRoute,
          initialRoute: Routes.splashView,
        ),
      ),
    );
  }
}
