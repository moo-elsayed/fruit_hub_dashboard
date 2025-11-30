import 'package:flutter/cupertino.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/views/products_view.dart';
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
      case Routes.productView:
        final args = arguments as FruitEntity?;
        return CupertinoPageRoute(
          builder: (_) => ProductView(fruitEntity: args),
        );
      case Routes.productsView:
        return CupertinoPageRoute(builder: (_) => const ProductsView());
      default:
        return null;
    }
  }
}
