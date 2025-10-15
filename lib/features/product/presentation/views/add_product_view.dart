import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/dependency_injection.dart';
import 'package:fruit_hub_dashboard/features/product/domain/use_cases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/product/presentation/managers/add_product_cubit/add_product_cubit.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import '../widgets/add_product_view_body.dart';
import '../widgets/custom_add_product_app_bar.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAddProductAppBar(title: "Add Product"),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => PickImageCubit()),
          BlocProvider(
            create: (context) =>
                AddProductCubit(getIt.get<AddProductUseCase>()),
          ),
        ],
        child: const AddProductViewBody(),
      ),
    );
  }
}
