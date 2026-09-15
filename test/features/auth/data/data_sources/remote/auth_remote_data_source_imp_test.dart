import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_strings.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/auth/data/data_sources/remote/auth_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/auth/data/models/sign_up_input_model.dart';
import 'package:fruit_hub_dashboard/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockAdditionalUserInfo extends Mock implements AdditionalUserInfo {}

class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthProvider());
  });

  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;
  late MockUser mockCurrentUser;
  late AuthRemoteDataSourceImp sut;

  const tUid = 'test_uid_123';
  const tEmail = 'test@example.com';
  const tPassword = 'Password123';
  const tUsername = 'Test User';
  const tPhone = '01012345678';

  const tSignUpInput = SignUpInputModel(
    username: tUsername,
    email: tEmail,
    password: tPassword,
    phone: tPhone,
  );

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    fakeFirestore = FakeFirebaseFirestore();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    mockCurrentUser = MockUser();

    when(() => mockUser.uid).thenReturn(tUid);
    when(() => mockUser.email).thenReturn(tEmail);
    when(() => mockUser.displayName).thenReturn(tUsername);
    when(() => mockUser.phoneNumber).thenReturn(tPhone);
    when(() => mockUser.emailVerified).thenReturn(true);
    when(() => mockUser.updateDisplayName(any())).thenAnswer((_) async {});
    when(() => mockUser.sendEmailVerification()).thenAnswer((_) async {});
    when(() => mockUser.reload()).thenAnswer((_) async {});
    when(() => mockUser.delete()).thenAnswer((_) async {});

    when(() => mockCurrentUser.uid).thenReturn(tUid);
    when(() => mockCurrentUser.email).thenReturn(tEmail);
    when(() => mockCurrentUser.displayName).thenReturn(tUsername);
    when(() => mockCurrentUser.emailVerified).thenReturn(true);
    when(() => mockCurrentUser.delete()).thenAnswer((_) async {});

    when(() => mockUserCredential.user).thenReturn(mockUser);
    when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
    when(() => mockFirebaseAuth.currentUser).thenReturn(mockCurrentUser);

    sut = AuthRemoteDataSourceImp(
      firebaseAuth: mockFirebaseAuth,
      firestore: fakeFirestore,
    );
  });

  group('createUserWithEmailAndPassword', () {
    test(
      'should successfully create user, update display name, save to Firestore, send verification, sign out and return NetworkSuccess',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user, isNotNull);
        expect(user!.uid, tUid);
        expect(user.name, tUsername);
        expect(user.email, tEmail);
        expect(user.phone, tPhone);

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['name'], tUsername);
        expect(doc.data()!['email'], tEmail);

        verify(() => mockUser.updateDisplayName(tUsername)).called(1);
        verify(() => mockUser.sendEmailVerification()).called(1);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should return NetworkFailure with unexpectedError and delete currentUser when userCredential.user is null',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.unexpectedError);
        verify(() => mockCurrentUser.delete()).called(1);
      },
    );

    test(
      'should return NetworkFailure with emailAlreadyInUse and NOT delete currentUser when FirebaseAuthException is email-already-in-use',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Email in use',
          ),
        );

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.emailAlreadyInUse);
        verifyNever(() => mockCurrentUser.delete());
      },
    );

    test(
      'should return NetworkFailure with thePasswordProvidedIsTooWeak and delete currentUser when FirebaseAuthException is weak-password',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'weak-password',
            message: 'Weak password',
          ),
        );

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.thePasswordProvidedIsTooWeak);
        verify(() => mockCurrentUser.delete()).called(1);
      },
    );

    test(
      'should return NetworkFailure with invalidEmail and delete currentUser when FirebaseAuthException is invalid-email',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'invalid-email',
            message: 'Invalid email',
          ),
        );

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.invalidEmail);
        verify(() => mockCurrentUser.delete()).called(1);
      },
    );

    test(
      'should return NetworkFailure with unexpectedError and delete currentUser when generic exception occurs',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(Exception('Unknown system error'));

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.unexpectedError);
        verify(() => mockCurrentUser.delete()).called(1);
      },
    );

    test(
      'should delete currentUser and return NetworkFailure when user.updateDisplayName throws an exception',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(
          () => mockUser.updateDisplayName(any()),
        ).thenThrow(Exception('Update display name failed'));

        // Act
        final result = await sut.createUserWithEmailAndPassword(tSignUpInput);

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        verify(() => mockCurrentUser.delete()).called(1);
      },
    );
  });

  group('signInWithEmailAndPassword', () {
    test(
      'should successfully sign in, reload user, update verified status in Firestore and return NetworkSuccess when user exists in DB',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'name': tUsername,
              'email': tEmail,
              'phone': tPhone,
              'isVerified': false,
            });

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.uid, tUid);
        expect(user.isVerified, isTrue);

        verify(() => mockUser.reload()).called(1);

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.data()!['isVerified'], isTrue);
      },
    );

    test(
      'should successfully sign in and create new Firestore doc if user did not exist in DB',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.uid, tUid);

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['uid'], tUid);
      },
    );

    test(
      'should return NetworkFailure with userNotFound when userCredential.user is null',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.userNotFound);
      },
    );

    test(
      'should sign out and return NetworkFailure with pleaseVerifyYourEmail when email is not verified',
      () async {
        // Arrange
        when(() => mockUser.emailVerified).thenReturn(false);
        when(() => mockCurrentUser.emailVerified).thenReturn(false);

        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.pleaseVerifyYourEmail);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should return NetworkFailure with wrongPasswordProvidedForThatUser on wrong-password code',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'wrong-password',
            message: 'Wrong password',
          ),
        );

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.wrongPasswordProvidedForThatUser);
      },
    );

    test(
      'should return NetworkFailure with invalidCredential on invalid-credential code',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'invalid-credential',
            message: 'Invalid credential',
          ),
        );

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.invalidCredential);
      },
    );

    test(
      'should return NetworkFailure with userDisabled on user-disabled code',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'user-disabled',
            message: 'User disabled',
          ),
        );

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.userDisabled);
      },
    );

    test(
      'should return NetworkFailure with noInternetConnection on network-request-failed code',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'network-request-failed',
            message: 'Network error',
          ),
        );

        // Act
        final result = await sut.signInWithEmailAndPassword(
          email: tEmail,
          password: tPassword,
        );

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.noInternetConnection);
      },
    );
  });

  group('googleSignIn', () {
    test(
      'should successfully sign in with Google provider and return NetworkSuccess with UserModel',
      () async {
        // Arrange
        final mockAdditionalInfo = MockAdditionalUserInfo();
        when(
          () => mockAdditionalInfo.profile,
        ).thenReturn({'picture': 'https://photo.url'});
        when(
          () => mockUserCredential.additionalUserInfo,
        ).thenReturn(mockAdditionalInfo);

        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.uid, tUid);
        expect(user.image, 'https://photo.url');

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.exists, isTrue);
      },
    );

    test(
      'should return NetworkFailure with unexpectedError when user is null',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenAnswer((_) async => mockUserCredential);
        when(() => mockUserCredential.user).thenReturn(null);

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.unexpectedError);
      },
    );

    test(
      'should return NetworkFailure with googleSignInCancelled when popup-closed-by-user exception is thrown',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenThrow(FirebaseAuthException(code: 'popup-closed-by-user'));

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.googleSignInCancelled);
      },
    );

    test(
      'should return NetworkFailure with accountExistsWithDifferentCredential when account-exists-with-different-credential code is thrown',
      () async {
        // Arrange
        when(() => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>()))).thenThrow(
          FirebaseAuthException(
            code: 'account-exists-with-different-credential',
          ),
        );

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.accountExistsWithDifferentCredential);
      },
    );

    test(
      'should preserve stored name when user already exists in DB with a non-empty name',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'name': 'Existing Custom Name',
              'email': tEmail,
              'isVerified': false,
            });

        final mockAdditionalInfo = MockAdditionalUserInfo();
        when(() => mockAdditionalInfo.profile).thenReturn(null);
        when(
          () => mockUserCredential.additionalUserInfo,
        ).thenReturn(mockAdditionalInfo);

        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.name, 'Existing Custom Name');
        expect(user.isVerified, isTrue);

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.data()!['name'], 'Existing Custom Name');
        expect(doc.data()!['isVerified'], isTrue);
      },
    );

    test(
      'should fallback to userModel.name when stored user in DB has an empty name',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'name': '   ',
              'email': tEmail,
              'isVerified': false,
            });

        final mockAdditionalInfo = MockAdditionalUserInfo();
        when(() => mockAdditionalInfo.profile).thenReturn(null);
        when(
          () => mockUserCredential.additionalUserInfo,
        ).thenReturn(mockAdditionalInfo);

        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.name, tUsername);

        final doc = await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .get();
        expect(doc.data()!['name'], tUsername);
      },
    );

    test(
      'should return NetworkFailure with unexpectedError on generic error',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signInWithProvider(any(that: isA<GoogleAuthProvider>())),
        ).thenThrow(Exception('Google OAuth failed'));

        // Act
        final result = await sut.googleSignIn();

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.unexpectedError);
      },
    );
  });

  group('forgetPassword', () {
    test(
      'should send password reset email when email exists in Firestore',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'email': tEmail,
              'name': tUsername,
              'isVerified': true,
            });

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).thenAnswer((_) async {});

        // Act
        final result = await sut.forgetPassword(tEmail);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).called(1);
      },
    );

    test(
      'should return NetworkFailure with noUserFoundForThatEmail and NOT call sendPasswordResetEmail when email does not exist in DB',
      () async {
        // Arrange - no user added to fakeFirestore

        // Act
        final result = await sut.forgetPassword('nonexistent@example.com');

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, AppStrings.noUserFoundForThatEmail);
        verifyNever(
          () => mockFirebaseAuth.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        );
      },
    );

    test(
      'should return NetworkFailure with invalidEmail when FirebaseAuthException is invalid-email',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'email': tEmail,
              'name': tUsername,
              'isVerified': true,
            });

        when(
          () => mockFirebaseAuth.sendPasswordResetEmail(email: tEmail),
        ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        // Act
        final result = await sut.forgetPassword(tEmail);

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, AppStrings.invalidEmail);
      },
    );
  });

  group('getUserInfo', () {
    test(
      'should return NetworkSuccess with UserModel when user document exists in Firestore',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'name': tUsername,
              'email': tEmail,
              'phone': tPhone,
              'isVerified': true,
            });

        // Act
        final result = await sut.getUserInfo(tUid);

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.uid, tUid);
        expect(user.name, tUsername);
        expect(user.email, tEmail);
        expect(user.phone, tPhone);
        expect(user.isVerified, isTrue);
      },
    );

    test(
      'should resolve isVerified to true if Firestore has false but auth currentUser has emailVerified true',
      () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.usersCollection)
            .doc(tUid)
            .set({
              'uid': tUid,
              'name': tUsername,
              'email': tEmail,
              'isVerified': false,
            });

        when(() => mockCurrentUser.emailVerified).thenReturn(true);

        // Act
        final result = await sut.getUserInfo(tUid);

        // Assert
        expect(result, isA<NetworkSuccess<UserModel>>());
        final user = (result as NetworkSuccess<UserModel>).data;
        expect(user!.isVerified, isTrue);
      },
    );

    test(
      'should return NetworkFailure with userNotFound when doc does not exist',
      () async {
        // Arrange - doc does not exist

        // Act
        final result = await sut.getUserInfo('non_existent_uid');

        // Assert
        expect(result, isA<NetworkFailure<UserModel>>());
        final failure = (result as NetworkFailure<UserModel>).failure;
        expect(failure.error, AppStrings.userNotFound);
      },
    );
  });

  group('signOut', () {
    test(
      'should call firebaseAuth.signOut and return NetworkSuccess',
      () async {
        // Arrange - default mock handles signOut successfully

        // Act
        final result = await sut.signOut();

        // Assert
        expect(result, isA<NetworkSuccess<void>>());
        verify(() => mockFirebaseAuth.signOut()).called(1);
      },
    );

    test(
      'should return NetworkFailure with unexpectedError when signOut throws an exception',
      () async {
        // Arrange
        when(
          () => mockFirebaseAuth.signOut(),
        ).thenThrow(Exception('Sign out failed'));

        // Act
        final result = await sut.signOut();

        // Assert
        expect(result, isA<NetworkFailure<void>>());
        final failure = (result as NetworkFailure<void>).failure;
        expect(failure.error, AppStrings.unexpectedError);
      },
    );
  });
}
