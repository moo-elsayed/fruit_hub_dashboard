import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/services/local_storage/app_preferences_service.dart';
import 'package:fruit_hub_dashboard/features/auth/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppPreferencesServiceImpl sut;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    sut = AppPreferencesServiceImpl(sharedPreferences);
  });

  const tUserEntity = UserEntity(
    uid: 'u1',
    name: 'Ahmed Mohamed',
    email: 'user@test.com',
    phone: '01012345678',
    image: 'https://example.com/avatar.png',
    isVerified: true,
  );

  group('AppPreferencesServiceImpl', () {
    group('getThemeMode & saveThemeMode', () {
      test('getThemeMode should return system by default when not set', () {
        expect(sut.getThemeMode(), equals('system'));
      });

      test('saveThemeMode should persist selected theme', () async {
        await sut.saveThemeMode('dark');
        expect(sut.getThemeMode(), equals('dark'));

        await sut.saveThemeMode('light');
        expect(sut.getThemeMode(), equals('light'));
      });
    });

    group('getLanguage & saveLanguage', () {
      test('getLanguage should return ar by default when not set', () {
        expect(sut.getLanguage(), equals('ar'));
      });

      test('saveLanguage should persist selected language', () async {
        await sut.saveLanguage('en');
        expect(sut.getLanguage(), equals('en'));

        await sut.saveLanguage('ar');
        expect(sut.getLanguage(), equals('ar'));
      });
    });

    group('getUser, saveUser & clearUser', () {
      test('getUser should return null when no user is cached', () {
        expect(sut.getUser(), isNull);
      });

      test('saveUser should persist UserEntity and getUser should retrieve it correctly', () async {
        await sut.saveUser(tUserEntity);

        final retrieved = sut.getUser();

        expect(retrieved, isNotNull);
        expect(retrieved?.uid, equals('u1'));
        expect(retrieved?.name, equals('Ahmed Mohamed'));
        expect(retrieved?.email, equals('user@test.com'));
        expect(retrieved?.phone, equals('01012345678'));
        expect(retrieved?.image, equals('https://example.com/avatar.png'));
        expect(retrieved?.isVerified, isTrue);
      });

      test(
        'getUser should return null when cached json is invalid or corrupted',
        () async {
          await sharedPreferences.setString('cached_user', 'invalid_json_data');

          expect(sut.getUser(), isNull);
        },
      );

      test('clearUser should remove cached user from preferences', () async {
        await sut.saveUser(tUserEntity);
        expect(sut.getUser(), isNotNull);

        await sut.clearUser();

        expect(sut.getUser(), isNull);
      });
    });

    group('isLoggedIn', () {
      test('isLoggedIn should return false when no user is cached', () {
        expect(sut.isLoggedIn(), isFalse);
      });

      test('isLoggedIn should return true when user is cached', () async {
        await sut.saveUser(tUserEntity);
        expect(sut.isLoggedIn(), isTrue);
      });

      test('isLoggedIn should return false after user is cleared', () async {
        await sut.saveUser(tUserEntity);
        expect(sut.isLoggedIn(), isTrue);

        await sut.clearUser();
        expect(sut.isLoggedIn(), isFalse);
      });
    });
  });
}
