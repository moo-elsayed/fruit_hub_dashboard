part of 'pick_image_cubit.dart';

@immutable
sealed class PickImageState {}

final class PickImageInitial extends PickImageState {}

final class PickImageSuccess extends PickImageState {
  PickImageSuccess(this.xFile);

  final XFile xFile;
}

final class PickImageFailure extends PickImageState {
  PickImageFailure(this.message);

  final String message;
}

final class ImageNotPicked extends PickImageState {}
