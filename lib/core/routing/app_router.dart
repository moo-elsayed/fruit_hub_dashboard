import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/views/products_view.dart';
import 'package:fruit_hub_dashboard/features/settings/presentation/views/settings_view.dart';
import 'package:fruit_hub_dashboard/features/users/presentation/views/users_view.dart';
import '../../features/orders/presentation/views/orders_view.dart';
import '../../features/products/presentation/managers/products_cubit/products_cubit.dart';
import '../../features/products/presentation/views/product_view.dart';
import '../../features/splash/presentation/views/animated_splash_view.dart';
import '../../features/auth/presentation/args/login_args.dart';
import '../../features/auth/presentation/views/forget_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashView:
        return CupertinoPageRoute(
          builder: (context) => const AnimatedSplashView(),
        );
      case Routes.loginView:
        final args = arguments as LoginArgs?;
        return CupertinoPageRoute(
          builder: (context) => LoginView(loginArgs: args),
        );
      case Routes.registerView:
        return CupertinoPageRoute(builder: (context) => const RegisterView());
      case Routes.forgetPasswordView:
        return CupertinoPageRoute(
          builder: (context) => const ForgetPasswordView(),
        );
      case Routes.dashboardView:
        return CupertinoPageRoute(builder: (_) => const DashboardView());
      case Routes.productsView:
        return CupertinoPageRoute(builder: (_) => const ProductsView());
      case Routes.productView:
        final args = arguments as List;
        return CupertinoPageRoute(
          builder: (_) => BlocProvider<ProductsCubit>.value(
            value: args[0] as ProductsCubit,
            child: ProductView(
              fruitEntity: args.length > 1 ? args[1] as FruitEntity? : null,
            ),
          ),
        );
      case Routes.usersView:
        return CupertinoPageRoute(builder: (_) => const UsersView());
      case Routes.settingsView:
        return CupertinoPageRoute(builder: (_) => const SettingsView());
      case Routes.ordersView:
        return CupertinoPageRoute(builder: (_) => const OrdersView());
      // case Routes.analyticsView:
      //   return CupertinoPageRoute(builder: (_) => const OrdersView());
      default:
        return null;
    }
  }
}
