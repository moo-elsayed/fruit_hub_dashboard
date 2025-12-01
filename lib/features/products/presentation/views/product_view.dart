import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/helpers/extentions.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_app_bar.dart';
import 'package:fruit_hub_dashboard/features/products/domain/entities/fruit_entity.dart';
import 'package:fruit_hub_dashboard/features/products/presentation/args/product_args.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import '../widgets/product_view_body.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key, this.fruitEntity});

  final FruitEntity? fruitEntity;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late ProductArgs _productArgs;

  @override
  void initState() {
    super.initState();
    _productArgs = ProductArgs();
    if (widget.fruitEntity != null) {
      _productArgs.setValues(widget.fruitEntity!);
    }
  }

  @override
  void dispose() {
    _productArgs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.fruitEntity == null ? "Add Product" : "Edit Product",
        showArrowBack: true,
        onTap: () => context.pop(),
      ),
      body: BlocProvider(
        create: (_) => PickImageCubit(),
        child: ProductViewBody(
          productArgs: _productArgs,
          imagePath: widget.fruitEntity?.imagePath ?? '',
        ),
      ),
    );
  }
}
