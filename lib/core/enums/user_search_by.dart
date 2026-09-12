import '../helpers/app_strings.dart';

enum UserSearchBy {
  name,
  email,
  phone;

  String get label => switch (this) {
    UserSearchBy.name => AppStrings.searchByName,
    UserSearchBy.email => AppStrings.searchByEmail,
    UserSearchBy.phone => AppStrings.searchByPhone,
  };
}
