import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/widgets/custom_product_image.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/widgets/featured_widget.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import '../widgets/custom_app_bar.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late XFile? _image;
  late bool _isFeatured;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Add Product"),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(24.h),
                CustomProductImage(onImageSelected: (value) => _image = value),
                Gap(24.h),
                TextFormFieldHelper(
                  controller: _nameController,
                  hint: "name",
                  keyboardType: TextInputType.name,
                  onValidate: (value) => Validator.validateName(val: value),
                  action: TextInputAction.next,
                ),
                Gap(16.h),
                TextFormFieldHelper(
                  controller: _descriptionController,
                  hint: "description",
                  keyboardType: TextInputType.name,
                  onValidate: (value) =>
                      Validator.validateName(val: value, type: "Description"),
                  maxLines: 5,
                  action: TextInputAction.next,
                ),
                Gap(16.h),
                TextFormFieldHelper(
                  controller: _priceController,
                  hint: "price",
                  keyboardType: TextInputType.number,
                  onValidate: (value) =>
                      Validator.validateName(val: value, type: "Price"),
                  action: TextInputAction.done,
                ),
                Gap(16.h),
                FeaturedWidget(onChanged: (value) => _isFeatured = value),
                Gap(30.h),
                CustomMaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  maxWidth: true,
                  text: "Add Product",
                  textStyle: AppTextStyles.font16WhiteBold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
