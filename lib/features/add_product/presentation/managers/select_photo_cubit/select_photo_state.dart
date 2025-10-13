part of 'select_photo_cubit.dart';

@immutable
sealed class SelectPhotoState {}

final class SelectPhotoInitial extends SelectPhotoState {}

final class SelectPhotoSuccess extends SelectPhotoState {
  SelectPhotoSuccess(this.xFile);

  final XFile xFile;
}

final class SelectPhotoFailure extends SelectPhotoState {
  SelectPhotoFailure(this.message);

  final String message;
}
