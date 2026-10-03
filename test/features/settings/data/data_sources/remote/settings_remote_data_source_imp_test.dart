import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/settings/data/data_sources/remote/settings_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_broadcast_notification_model.dart';
import 'package:fruit_hub_dashboard/features/settings/data/models/shipping_config_model.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_broadcast_notification_entity.dart';
import 'package:fruit_hub_dashboard/features/settings/domain/entities/shipping_config_entity.dart';

void main() {
  group('SettingsRemoteDataSourceImp', () {
    late FakeFirebaseFirestore fakeFirestore;
    late SettingsRemoteDataSourceImp sut;

    const tNotificationModel = ShippingBroadcastNotificationModel(
      titleAr: 'تحديث الشحن',
      titleEn: 'Shipping Update',
      bodyAr: 'تم تحديث مصاريف الشحن لجميع الطلبات',
      bodyEn: 'Shipping cost has been updated for all orders',
      type: 'shipping',
      notify: true,
    );

    const tShippingConfigModel = ShippingConfigModel(
      shippingCost: 50.0,
      freeShippingThreshold: 350.0,
      broadcastNotification: tNotificationModel,
    );

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      sut = SettingsRemoteDataSourceImp(firestore: fakeFirestore);
    });

    group('fetchShippingConfig', () {
      test('should return NetworkSuccess with default ShippingConfigModel(shippingCost: 0.0) when document does not exist', () async {
        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigModel>>());
        final data = (result as NetworkSuccess<ShippingConfigModel>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 0.0);
        expect(data.freeShippingThreshold, 0.0);
        expect(data.broadcastNotification, isNull);
      });

      test('should return NetworkSuccess with properly parsed ShippingConfigModel when document exists with full fields', () async {
        // Arrange
        await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .set({
              'shipping_cost': 45.0,
              'free_shipping_threshold': 300.0,
              'broadcast_notification': {
                'notify': true,
                'titleAr': 'شحن مجاني',
                'titleEn': 'Free Shipping',
                'bodyAr': 'شحن مجاني للطلبات فوق 300 جنيه',
                'bodyEn': 'Free shipping for orders over 300 EGP',
                'type': 'shipping',
              },
            });

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigModel>>());
        final data = (result as NetworkSuccess<ShippingConfigModel>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 45.0);
        expect(data.freeShippingThreshold, 300.0);
        expect(data.broadcastNotification, isNotNull);
        expect(data.broadcastNotification!.notify, isTrue);
        expect(data.broadcastNotification!.titleAr, 'شحن مجاني');
        expect(data.broadcastNotification!.titleEn, 'Free Shipping');
        expect(
          data.broadcastNotification!.bodyAr,
          'شحن مجاني للطلبات فوق 300 جنيه',
        );
        expect(
          data.broadcastNotification!.bodyEn,
          'Free shipping for orders over 300 EGP',
        );
        expect(data.broadcastNotification!.type, 'shipping');
      });

      test('should fallback to default values when optional fields are missing in Firestore document', () async {
        // Arrange - only shipping_cost provided
        await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .set({'shipping_cost': 35.5});

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigModel>>());
        final data = (result as NetworkSuccess<ShippingConfigModel>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 35.5);
        expect(data.freeShippingThreshold, 0.0);
        expect(data.broadcastNotification, isNull);
      });

      test('should convert integer values to double without error', () async {
        // Arrange - integers instead of doubles
        await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .set({'shipping_cost': 40, 'free_shipping_threshold': 200});

        // Act
        final result = await sut.fetchShippingConfig();

        // Assert
        expect(result, isA<NetworkSuccess<ShippingConfigModel>>());
        final data = (result as NetworkSuccess<ShippingConfigModel>).data;
        expect(data, isNotNull);
        expect(data!.shippingCost, 40.0);
        expect(data.freeShippingThreshold, 200.0);
      });
    });

    group('updateShippingConfig', () {
      test('should update document in Firestore with merge true and return NetworkSuccess(null) when notify is true', () async {
        // Act
        final result = await sut.updateShippingConfig(tShippingConfigModel);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final docSnap = await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .get();

        expect(docSnap.exists, isTrue);
        final data = docSnap.data()!;
        expect(data['shipping_cost'], 50.0);
        expect(data['free_shipping_threshold'], 350.0);

        final notifData =
            data['broadcast_notification'] as Map<String, dynamic>?;
        expect(notifData, isNotNull);
        expect(notifData!['notify'], isTrue);
        expect(notifData['titleAr'], 'تحديث الشحن');
        expect(notifData['titleEn'], 'Shipping Update');
        expect(notifData['bodyAr'], 'تم تحديث مصاريف الشحن لجميع الطلبات');
        expect(
          notifData['bodyEn'],
          'Shipping cost has been updated for all orders',
        );
        expect(notifData['type'], 'shipping');
        expect(notifData['isRead'], isFalse);
        expect(notifData['source'], 'admin_dashboard');
        expect(notifData['pushSent'], isFalse);
        expect(notifData['createdAt'], isNotNull);
      });

      test('should omit broadcast_notification from Firestore when broadcastNotification is null', () async {
        // Arrange
        const configWithoutNotif = ShippingConfigModel(
          shippingCost: 30.0,
          freeShippingThreshold: 150.0,
          broadcastNotification: null,
        );

        // Act
        final result = await sut.updateShippingConfig(configWithoutNotif);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final docSnap = await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .get();

        expect(docSnap.exists, isTrue);
        final data = docSnap.data()!;
        expect(data['shipping_cost'], 30.0);
        expect(data['free_shipping_threshold'], 150.0);
        expect(data.containsKey('broadcast_notification'), isFalse);
      });

      test('should omit broadcast_notification from Firestore when broadcastNotification notify is false', () async {
        // Arrange
        const configWithNotifyFalse = ShippingConfigModel(
          shippingCost: 25.0,
          freeShippingThreshold: 100.0,
          broadcastNotification: ShippingBroadcastNotificationModel(
            titleAr: 'ع',
            titleEn: 'T',
            bodyAr: 'ب',
            bodyEn: 'B',
            notify: false,
          ),
        );

        // Act
        final result = await sut.updateShippingConfig(configWithNotifyFalse);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final docSnap = await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .get();

        expect(docSnap.exists, isTrue);
        final data = docSnap.data()!;
        expect(data['shipping_cost'], 25.0);
        expect(data['free_shipping_threshold'], 100.0);
        expect(data.containsKey('broadcast_notification'), isFalse);
      });

      test('should preserve existing fields in document due to SetOptions(merge: true)', () async {
        // Arrange - document already has existing unrelated fields
        await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .set({
              'app_version': '1.0.0',
              'maintenance_mode': false,
              'shipping_cost': 10.0,
            });

        const newConfig = ShippingConfigModel(
          shippingCost: 60.0,
          freeShippingThreshold: 500.0,
        );

        // Act
        final result = await sut.updateShippingConfig(newConfig);

        // Assert
        expect(result, isA<NetworkSuccess<void>>());

        final docSnap = await fakeFirestore
            .collection(BackendEndpoints.constantsCollection)
            .doc(BackendEndpoints.shippingConfigDocId)
            .get();

        final data = docSnap.data()!;
        // Existing fields preserved
        expect(data['app_version'], '1.0.0');
        expect(data['maintenance_mode'], false);
        // Shipping config fields updated
        expect(data['shipping_cost'], 60.0);
        expect(data['free_shipping_threshold'], 500.0);
      });
    });

    group('Model and Entity Mappings', () {
      test('ShippingConfigModel toEntity and fromEntity should map all properties correctly', () {
        const entity = ShippingConfigEntity(
          shippingCost: 55.0,
          freeShippingThreshold: 400.0,
          broadcastNotification: ShippingBroadcastNotificationEntity(
            titleAr: 'عنوان',
            titleEn: 'Title',
            bodyAr: 'محتوى',
            bodyEn: 'Body',
            type: 'general',
            notify: true,
          ),
        );

        final model = ShippingConfigModel.fromEntity(entity);
        expect(model.shippingCost, entity.shippingCost);
        expect(model.freeShippingThreshold, entity.freeShippingThreshold);
        expect(model.broadcastNotification, isNotNull);
        expect(model.broadcastNotification!.titleAr, 'عنوان');
        expect(model.broadcastNotification!.titleEn, 'Title');
        expect(model.broadcastNotification!.bodyAr, 'محتوى');
        expect(model.broadcastNotification!.bodyEn, 'Body');
        expect(model.broadcastNotification!.type, 'general');
        expect(model.broadcastNotification!.notify, isTrue);

        final mappedEntity = model.toEntity();
        expect(mappedEntity.shippingCost, entity.shippingCost);
        expect(
          mappedEntity.freeShippingThreshold,
          entity.freeShippingThreshold,
        );
        expect(mappedEntity.broadcastNotification, isNotNull);
        expect(
          mappedEntity.broadcastNotification!.titleAr,
          entity.broadcastNotification!.titleAr,
        );
        expect(
          mappedEntity.broadcastNotification!.titleEn,
          entity.broadcastNotification!.titleEn,
        );
        expect(
          mappedEntity.broadcastNotification!.bodyAr,
          entity.broadcastNotification!.bodyAr,
        );
        expect(
          mappedEntity.broadcastNotification!.bodyEn,
          entity.broadcastNotification!.bodyEn,
        );
        expect(
          mappedEntity.broadcastNotification!.type,
          entity.broadcastNotification!.type,
        );
        expect(
          mappedEntity.broadcastNotification!.notify,
          entity.broadcastNotification!.notify,
        );
      });

      test('ShippingConfigModel fromEntity should handle null broadcastNotification correctly', () {
        const entity = ShippingConfigEntity(
          shippingCost: 20.0,
          freeShippingThreshold: 100.0,
          broadcastNotification: null,
        );

        final model = ShippingConfigModel.fromEntity(entity);
        expect(model.shippingCost, 20.0);
        expect(model.freeShippingThreshold, 100.0);
        expect(model.broadcastNotification, isNull);

        final mappedEntity = model.toEntity();
        expect(mappedEntity.shippingCost, 20.0);
        expect(mappedEntity.freeShippingThreshold, 100.0);
        expect(mappedEntity.broadcastNotification, isNull);
      });

      test('ShippingConfigModel.fromJson should parse valid map and fallback on empty/null values', () {
        final emptyJsonModel = ShippingConfigModel.fromJson({});
        expect(emptyJsonModel.shippingCost, 0.0);
        expect(emptyJsonModel.freeShippingThreshold, 0.0);
        expect(emptyJsonModel.broadcastNotification, isNull);

        final nullJsonModel = ShippingConfigModel.fromJson({
          'shipping_cost': null,
          'free_shipping_threshold': null,
          'broadcast_notification': null,
        });
        expect(nullJsonModel.shippingCost, 0.0);
        expect(nullJsonModel.freeShippingThreshold, 0.0);
        expect(nullJsonModel.broadcastNotification, isNull);
      });

      test('ShippingBroadcastNotificationModel toEntity and fromEntity should map correctly', () {
        const entity = ShippingBroadcastNotificationEntity(
          titleAr: 'تنبيه',
          titleEn: 'Alert',
          bodyAr: 'تفاصيل',
          bodyEn: 'Details',
          type: 'promo',
          notify: true,
        );

        final model = ShippingBroadcastNotificationModel.fromEntity(entity);
        expect(model.titleAr, entity.titleAr);
        expect(model.titleEn, entity.titleEn);
        expect(model.bodyAr, entity.bodyAr);
        expect(model.bodyEn, entity.bodyEn);
        expect(model.type, entity.type);
        expect(model.notify, entity.notify);

        final mappedEntity = model.toEntity();
        expect(mappedEntity.titleAr, entity.titleAr);
        expect(mappedEntity.titleEn, entity.titleEn);
        expect(mappedEntity.bodyAr, entity.bodyAr);
        expect(mappedEntity.bodyEn, entity.bodyEn);
        expect(mappedEntity.type, entity.type);
        expect(mappedEntity.notify, entity.notify);
      });

      test('ShippingBroadcastNotificationModel.fromJson should fallback on missing/null fields', () {
        final model = ShippingBroadcastNotificationModel.fromJson({});
        expect(model.titleAr, '');
        expect(model.titleEn, '');
        expect(model.bodyAr, '');
        expect(model.bodyEn, '');
        expect(model.type, 'general');
        expect(model.notify, isFalse);
      });

      test('ShippingBroadcastNotificationModel.toJson should include all required metadata fields', () {
        const model = ShippingBroadcastNotificationModel(
          titleAr: 'عنوان',
          titleEn: 'Title',
          bodyAr: 'محتوى',
          bodyEn: 'Body',
          type: 'general',
          notify: true,
        );

        final json = model.toJson();
        expect(json['notify'], isTrue);
        expect(json['titleAr'], 'عنوان');
        expect(json['titleEn'], 'Title');
        expect(json['bodyAr'], 'محتوى');
        expect(json['bodyEn'], 'Body');
        expect(json['type'], 'general');
        expect(json['isRead'], isFalse);
        expect(json['source'], 'admin_dashboard');
        expect(json['pushSent'], isFalse);
        expect(json['processed'], isFalse);
        expect(json['createdAt'], isA<FieldValue>());
      });
    });
  });
}
