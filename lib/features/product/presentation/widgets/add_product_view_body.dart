import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/widgets/app_toasts.dart';
import 'package:fruit_hub_dashboard/features/product/presentation/managers/add_product_cubit/add_product_cubit.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/helpers/validator.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/custom_material_button.dart';
import '../../../../core/widgets/text_form_field_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/fruit_entity.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';
import 'custom_product_image.dart';
import 'custom_switch_container.dart';

class AddProductViewBody extends StatefulWidget {
  const AddProductViewBody({super.key});

  @override
  State<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends State<AddProductViewBody> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _codeController;
  late TextEditingController _descriptionController;
  late TextEditingController _numberOfCaloriesController;
  late TextEditingController _unitAmountController;
  late TextEditingController _monthsUntilExpirationController;
  XFile? _image;
  bool _isFeatured = false;
  bool _isOrganic = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _codeController = TextEditingController();
    _descriptionController = TextEditingController();
    _numberOfCaloriesController = TextEditingController();
    _unitAmountController = TextEditingController();
    _monthsUntilExpirationController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _codeController.dispose();
    _descriptionController.dispose();
    _numberOfCaloriesController.dispose();
    _unitAmountController.dispose();
    _monthsUntilExpirationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gap(24.h),
              CustomProductImage(
                onImageSelected: (value) => _image = value,
                size: size,
              ),
              Gap(24.h),
              TextFormFieldHelper(
                controller: _nameController,
                labelText: "name",
                keyboardType: TextInputType.name,
                onValidate: (value) => Validator.validateName(val: value),
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: _priceController,
                labelText: "price",
                keyboardType: TextInputType.number,
                onValidate: (value) =>
                    Validator.validateName(val: value, type: "Price"),
                action: TextInputAction.next,
              ),
              Gap(16.h),
              TextFormFieldHelper(
                controller: _descriptionController,
                labelText: "description",
                keyboardType: TextInputType.name,
                onValidate: (value) =>
                    Validator.validateName(val: value, type: "Description"),
                maxLines: 5,
                minLines: 5,
                action: TextInputAction.next,
              ),
              Gap(16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: _monthsUntilExpirationController,
                      labelText: "months until expiration",
                      keyboardType: TextInputType.number,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "months until expiration",
                      ),
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: _codeController,
                      labelText: "code",
                      keyboardType: TextInputType.name,
                      onValidate: Validator.validateCode,
                      action: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.w,
                children: [
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: _numberOfCaloriesController,
                      labelText: "number of calories",
                      keyboardType: TextInputType.number,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "number of calories",
                      ),
                      action: TextInputAction.next,
                    ),
                  ),
                  Expanded(
                    child: TextFormFieldHelper(
                      controller: _unitAmountController,
                      labelText: "unit amount per gram",
                      keyboardType: TextInputType.name,
                      onValidate: (value) => Validator.validateName(
                        val: value,
                        type: "number of calories",
                      ),
                      action: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: CustomSwitchContainer(
                      onChanged: (value) => _isOrganic = value,
                      text: "Organic",
                    ),
                  ),
                  Expanded(
                    child: CustomSwitchContainer(
                      onChanged: (value) => _isFeatured = value,
                      text: "Featured",
                    ),
                  ),
                ],
              ),
              Gap(30.h),
              BlocConsumer<AddProductCubit, AddProductState>(
                listener: (context, state) {
                  if (state is AddProductSuccess) {
                    AppToast.showToast(
                      context: context,
                      title: "Product Added Successfully",
                      type: ToastificationType.success,
                    );
                  } else if (state is AddProductFailure) {
                    AppToast.showToast(
                      context: context,
                      title: state.errorMessage,
                      type: ToastificationType.error,
                    );
                  }
                },
                builder: (context, state) {
                  return CustomMaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _image != null) {
                        var fruitEntity = FruitEntity(
                          image: _image,
                          isFeatured: _isFeatured,
                          isOrganic: _isOrganic,
                          name: _nameController.text.trim(),
                          code: _codeController.text.toLowerCase().trim(),
                          description: _descriptionController.text.trim(),
                          price: double.parse(_priceController.text),
                          numberOfCalories: int.parse(
                            _numberOfCaloriesController.text,
                          ),
                          unitAmount: int.parse(_unitAmountController.text),
                          monthsUntilExpiration: int.parse(
                            _monthsUntilExpirationController.text,
                          ),
                        );
                        context.read<AddProductCubit>().addProduct(fruitEntity);
                      }
                      if (_image == null) {
                        context.read<PickImageCubit>().imageNotPicked();
                      }
                    },
                    isLoading: state is AddProductLoading,
                    maxWidth: true,
                    text: "Add Product",
                    textStyle: AppTextStyles.font16WhiteBold,
                  );
                },
              ),
              Gap(24.h),
            ],
          ),
        ),
      ),
    );
  }
}
