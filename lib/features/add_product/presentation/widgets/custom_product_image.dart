import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fruit_hub_dashboard/core/theming/app_colors.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/managers/select_photo_cubit/select_photo_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/app_toasts.dart';

class CustomProductImage extends StatefulWidget {
  const CustomProductImage({super.key, required this.onImageSelected});

  final ValueChanged<XFile?> onImageSelected;

  @override
  State<CustomProductImage> createState() => _CustomProductImageState();
}

class _CustomProductImageState extends State<CustomProductImage> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectPhotoCubit(),
      child: BlocConsumer<SelectPhotoCubit, SelectPhotoState>(
        listener: (context, state) {
          if (state is SelectPhotoSuccess) {
            _image = state.xFile;
            widget.onImageSelected(state.xFile);
          }
          if (state is SelectPhotoFailure) {
            AppToast.showToast(
              context: context,
              title: state.message,
              type: ToastificationType.error,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              CircleAvatar(
                radius: 75.r,
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path))
                    : null,
              ),
              Positioned(
                bottom: 2.h,
                right: 4.w,
                child: GestureDetector(
                  onTap: () {
                    if (_image != null) {
                      setState(() {
                        _image = null;
                        widget.onImageSelected(null);
                      });
                    } else {
                      context.read<SelectPhotoCubit>().selectImage();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _image != null ? AppColors.red : AppColors.white,
                    ),
                    child: Icon(
                      _image != null
                          ? CupertinoIcons.clear
                          : CupertinoIcons.camera,
                      size: 20.r,
                      color: _image != null ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
