import 'package:flutter/cupertino.dart';
import 'package:fruit_hub_dashboard/core/routing/routes.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/views/add_product_view.dart';
import '../../features/dashboard/presentation/views/dashboard_view.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.dashboardView:
        return CupertinoPageRoute(builder: (_) => const DashboardView());
      case Routes.addProductView:
        return CupertinoPageRoute(builder: (_) => const AddProductView());
      default:
        return null;
    }
  }
}
