import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/di.dart';
import 'package:fruit_hub_dashboard/features/auth/presentation/managers/signout_cubit/sign_out_cubit.dart';

import '../widgets/custom_dashboard_app_bar.dart';
import '../widgets/dashboard_view_body.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final _ = EasyLocalization.of(context)?.locale;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocProvider(
          create: (context) => getIt.get<SignOutCubit>(),
          child: const CustomDashboardAppBar(),
        ),
      ),
      body: const DashboardViewBody(),
    );
  }
}
