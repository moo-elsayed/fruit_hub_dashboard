import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/widgets/app_toasts.dart';
import '../managers/pick_image_cubit/pick_image_cubit.dart';

class CustomProductImage extends StatefulWidget {
  const CustomProductImage({
    super.key,
    required this.onImageSelected,
    required this.size,
    required this.imagePath,
    required this.onShowMyImageChanged,
  });

  final ValueChanged<XFile?> onImageSelected;
  final ValueChanged<bool> onShowMyImageChanged;
  final Size size;
  final String imagePath;

  @override
  State<CustomProductImage> createState() => _CustomProductImageState();
}

class _CustomProductImageState extends State<CustomProductImage> {
  XFile? _image;
  late bool showMyImage = widget.imagePath != '';

  @override
  Widget build(BuildContext context) => BlocConsumer<PickImageCubit, PickImageState>(
      listener: (context, state) {
        if (state is PickImageSuccess) {
          _image = state.xFile;
          widget.onImageSelected(state.xFile);
        }
        if (state is PickImageFailure) {
          AppToast.showToast(
            context: context,
            title: state.message,
            type: ToastificationType.error,
          );
        }
      },
      builder: (context, state) => Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_image == null) {
                      context.read<PickImageCubit>().pickImage();
                    }
                  },
                  child: Container(
                    height: 150.h,
                    width: (widget.size.width / 2),
                    decoration: BoxDecoration(
                      color: AppColors.colorEEEEEE,
                      borderRadius: .circular(12.r),
                      border: .all(
                        color: state is ImageNotPicked
                            ? AppColors.red
                            : AppColors.grey,
                      ),
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(File(_image!.path)),
                              fit: BoxFit.contain,
                            )
                          : null,
                    ),
                    child: _image == null && showMyImage
                        ? CustomNetworkImage(image: widget.imagePath)
                        : _image == null
                        ? Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                ),
                Visibility(
                  visible: _image != null || showMyImage,
                  child: Positioned(
                    top: 2.h,
                    right: 2.w,
                    child: GestureDetector(
                      onTap: () {
                        if (showMyImage) {
                          showMyImage = false;
                          widget.onShowMyImageChanged(showMyImage);
                        }
                        _image = null;
                        widget.onImageSelected(null);
                        context.read<PickImageCubit>().unpickImage();
                      },
                      child: Container(
                        padding: .all(6.r),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.red,
                        ),
                        child: Icon(
                          CupertinoIcons.clear,
                          size: 12.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: state is ImageNotPicked,
              child: Padding(
                padding: .only(top: 8.h),
                child: Text(
                  'Please select an image',
                  style: AppTextStyles.font13color0C0D0DSemiBold.copyWith(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
    );
}
