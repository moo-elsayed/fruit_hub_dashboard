import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageInitial());

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      emit(PickImageSuccess(xFile));
    } else {
      emit(PickImageFailure('No image selected.'));
    }
  }

  void unpickImage() => emit(ImageNotPicked());

  void imageNotPicked() => emit(ImageNotPicked());
}
