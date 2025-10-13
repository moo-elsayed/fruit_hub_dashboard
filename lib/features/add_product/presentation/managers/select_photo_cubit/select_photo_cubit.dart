import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'select_photo_state.dart';

class SelectPhotoCubit extends Cubit<SelectPhotoState> {
  SelectPhotoCubit() : super(SelectPhotoInitial());

  Future<void> selectImage() async {
    final ImagePicker picker = ImagePicker();
    var xFile = await picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      emit(SelectPhotoSuccess(xFile));
    } else {
      emit(SelectPhotoFailure("No image selected."));
    }
  }
}
