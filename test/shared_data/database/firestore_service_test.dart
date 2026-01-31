import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/shared_data/services/database/firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  late FirestoreService sut;
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    sut = FirestoreService(fakeFirestore);
  });

  group('FirestoreService', () {
    group('streamAllData', () {
      const tPath = 'orders';
      test(
        'streamAllData emits data AND injects docId correctly when includeDocId is true',
        () async {
          // Arrange
          await fakeFirestore.collection(tPath).doc('doc_123').set({
            'totalPrice': 100,
            'status': 'pending',
          });
          // Act
          final stream = sut.streamAllData(path: tPath, includeDocId: true);
          // Assert
          expect(
            stream,
            emits([
              {'totalPrice': 100, 'status': 'pending', 'docId': 'doc_123'},
            ]),
          );
        },
      );
      test(
        'streamAllData emits data AND injects docId correctly when includeDocId is false',
        () async {
          // Arrange
          await fakeFirestore.collection(tPath).doc('doc_123').set({
            'totalPrice': 100,
            'status': 'pending',
          });
          // Act
          final stream = sut.streamAllData(path: tPath);
          // Assert
          expect(
            stream,
            emits([
              {'totalPrice': 100, 'status': 'pending'},
            ]),
          );
        },
      );
    });
  });
}
