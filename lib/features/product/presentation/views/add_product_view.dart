import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import '../widgets/add_product_view_body.dart';
import '../widgets/custom_app_bar.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Add Product"),
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => PickImageCubit())],
        child: const AddProductViewBody(),
      ),
    );
  }
}
