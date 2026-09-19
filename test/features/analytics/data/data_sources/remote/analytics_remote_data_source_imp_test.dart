import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/enums/payment_methods.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/data_sources/remote/analytics_remote_data_source_imp.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_data_model.dart';

void main() {
  group('AnalyticsRemoteDataSourceImp', () {
    late FakeFirebaseFirestore fakeFirestore;
    late AnalyticsRemoteDataSourceImp sut;

    const usersCollection = BackendEndpoints.usersCollection;
    const dailyCollection = BackendEndpoints.analyticsDailyCollection;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      sut = AnalyticsRemoteDataSourceImp(firestore: fakeFirestore);
    });

    Map<String, dynamic> createDailyDocMap({
      double revenue = 1500.0,
      int ordersCount = 5,
      Map<String, dynamic>? orderStatuses,
      Map<String, dynamic>? paymentMethods,
      Map<String, dynamic>? products,
    }) => {
      'revenue': revenue,
      'ordersCount': ordersCount,
      'orderStatuses': ?orderStatuses,
      'paymentMethods': ?paymentMethods,
      'products': ?products,
    };

    Future<void> addUser({
      required String uid,
      bool isVerified = false,
      List<dynamic>? cartItems,
    }) async {
      await fakeFirestore.collection(usersCollection).doc(uid).set({
        'uid': uid,
        'isVerified': isVerified,
        if (cartItems != null && cartItems.isNotEmpty) 'cartItems': cartItems,
      });
    }

    String dateKey(DateTime dt) =>
        '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';

    group('getAnalytics', () {
      test('returns NetworkSuccess with zeroed KPI, empty products, and zero-filled timeline when collections are empty', () async {
        final from = DateTime(2026, 9, 1);
        final to = DateTime(2026, 9, 3);

        final response = await sut.getAnalytics(from: from, to: to);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        // KPI checks
        expect(data.kpi.totalRevenue, 0.0);
        expect(data.kpi.totalOrders, 0);
        expect(data.kpi.deliveredOrders, 0);
        expect(data.kpi.cancelledOrders, 0);
        expect(data.kpi.pendingOrders, 0);
        expect(data.kpi.processingOrders, 0);
        expect(data.kpi.shippedOrders, 0);
        expect(data.kpi.totalUsers, 0);
        expect(data.kpi.verifiedUsers, 0);
        expect(data.kpi.activeCartsCount, 0);
        expect(data.kpi.deliveryRate, 0.0);
        expect(data.kpi.cancellationRate, 0.0);

        // Timeline checks (3 days: 2026-09-01, 2026-09-02, 2026-09-03)
        expect(data.revenueOverTime.length, 3);
        expect(data.revenueOverTime[0].date, DateTime(2026, 9, 1));
        expect(data.revenueOverTime[0].revenue, 0.0);
        expect(data.revenueOverTime[0].ordersCount, 0);
        expect(data.revenueOverTime[1].date, DateTime(2026, 9, 2));
        expect(data.revenueOverTime[1].revenue, 0.0);
        expect(data.revenueOverTime[1].ordersCount, 0);
        expect(data.revenueOverTime[2].date, DateTime(2026, 9, 3));
        expect(data.revenueOverTime[2].revenue, 0.0);
        expect(data.revenueOverTime[2].ordersCount, 0);

        // Top products
        expect(data.topProducts, isEmpty);

        // Order status stats
        expect(data.orderStatusStats.length, OrderStatus.values.length);
        for (final stat in data.orderStatusStats) {
          expect(stat.count, 0);
        }

        // Payment method stats
        expect(data.paymentMethodStats.length, PaymentMethodType.values.length);
        for (final stat in data.paymentMethodStats) {
          expect(stat.count, 0);
        }
      });

      test('returns correct data when from and to represent the same single day', () async {
        final day = DateTime(2026, 9, 15);
        final docKey = dateKey(day);

        await fakeFirestore.collection(dailyCollection).doc(docKey).set(
          createDailyDocMap(
            revenue: 2500.0,
            ordersCount: 8,
            orderStatuses: {
              'deliveredOrders': 5,
              'pendingOrders': 2,
              'cancelledOrders': 1,
            },
            paymentMethods: {
              'cash_on_delivery': 3,
              'credit_card': 5,
            },
            products: {
              'APL': {
                'name': 'Apple',
                'imagePath': 'apple.png',
                'quantitySold': 10,
                'revenue': 500.0,
              },
            },
          ),
        );

        final response = await sut.getAnalytics(from: day, to: day);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.kpi.totalRevenue, 2500.0);
        expect(data.kpi.totalOrders, 8);
        expect(data.kpi.deliveredOrders, 5);
        expect(data.kpi.pendingOrders, 2);
        expect(data.kpi.cancelledOrders, 1);
        expect(data.kpi.deliveryRate, (5 / 8) * 100);
        expect(data.kpi.cancellationRate, (1 / 8) * 100);

        expect(data.revenueOverTime.length, 1);
        expect(data.revenueOverTime.first.date, DateTime(2026, 9, 15));
        expect(data.revenueOverTime.first.revenue, 2500.0);
        expect(data.revenueOverTime.first.ordersCount, 8);

        expect(data.topProducts.length, 1);
        expect(data.topProducts.first.code, 'APL');
        expect(data.topProducts.first.name, 'Apple');
        expect(data.topProducts.first.imagePath, 'apple.png');
        expect(data.topProducts.first.totalQuantitySold, 10);
        expect(data.topProducts.first.totalRevenue, 500.0);
      });

      test('aggregates revenue, ordersCount, statuses, and payments across multiple days', () async {
        final day1 = DateTime(2026, 9, 10);
        final day2 = DateTime(2026, 9, 11);
        final day3 = DateTime(2026, 9, 12);

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day1)).set(
          createDailyDocMap(
            revenue: 1200.0,
            ordersCount: 4,
            orderStatuses: {
              'deliveredOrders': 2,
              'pendingOrders': 2,
            },
            paymentMethods: {
              'cash_on_delivery': 2,
              'credit_card': 2,
            },
          ),
        );

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day2)).set(
          createDailyDocMap(
            revenue: 800.0,
            ordersCount: 3,
            orderStatuses: {
              'deliveredOrders': 1,
              'shippedOrders': 1,
              'cancelledOrders': 1,
            },
            paymentMethods: {
              'credit_card': 2,
              'paypal': 1,
            },
          ),
        );

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day3)).set(
          createDailyDocMap(
            revenue: 2500.0,
            ordersCount: 5,
            orderStatuses: {
              'deliveredOrders': 4,
              'processingOrders': 1,
            },
            paymentMethods: {
              'cash_on_delivery': 1,
              'paypal': 4,
            },
          ),
        );

        final response = await sut.getAnalytics(from: day1, to: day3);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        // KPI Totals: 1200 + 800 + 2500 = 4500
        expect(data.kpi.totalRevenue, 4500.0);
        // Total Orders: 4 + 3 + 5 = 12
        expect(data.kpi.totalOrders, 12);
        // Statuses
        expect(data.kpi.deliveredOrders, 7);
        expect(data.kpi.pendingOrders, 2);
        expect(data.kpi.shippedOrders, 1);
        expect(data.kpi.processingOrders, 1);
        expect(data.kpi.cancelledOrders, 1);
        expect(data.kpi.deliveryRate, closeTo((7 / 12) * 100, 0.001));
        expect(data.kpi.cancellationRate, closeTo((1 / 12) * 100, 0.001));

        // Timeline
        expect(data.revenueOverTime.length, 3);
        expect(data.revenueOverTime[0].revenue, 1200.0);
        expect(data.revenueOverTime[0].ordersCount, 4);
        expect(data.revenueOverTime[1].revenue, 800.0);
        expect(data.revenueOverTime[1].ordersCount, 3);
        expect(data.revenueOverTime[2].revenue, 2500.0);
        expect(data.revenueOverTime[2].ordersCount, 5);

        // Payment stats breakdown:
        // cash_on_delivery = 2 + 0 + 1 = 3
        // credit_card = 2 + 2 + 0 = 4
        // paypal = 0 + 1 + 4 = 5
        final cashStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.cash);
        final cardStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.card);
        final paypalStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.paypal);

        expect(cashStat.count, 3);
        expect(cardStat.count, 4);
        expect(paypalStat.count, 5);

        // Status stats breakdown
        final deliveredStat = data.orderStatusStats.firstWhere((s) => s.status == OrderStatus.delivered);
        final pendingStat = data.orderStatusStats.firstWhere((s) => s.status == OrderStatus.pending);
        final shippedStat = data.orderStatusStats.firstWhere((s) => s.status == OrderStatus.shipped);
        final processingStat = data.orderStatusStats.firstWhere((s) => s.status == OrderStatus.processing);
        final cancelledStat = data.orderStatusStats.firstWhere((s) => s.status == OrderStatus.cancelled);

        expect(deliveredStat.count, 7);
        expect(pendingStat.count, 2);
        expect(shippedStat.count, 1);
        expect(processingStat.count, 1);
        expect(cancelledStat.count, 1);
      });

      test('fills missing calendar days with zero revenue and zero orders in continuous timeline', () async {
        // 5 days range: Sep 1 to Sep 5
        final day1 = DateTime(2026, 9, 1);
        final day4 = DateTime(2026, 9, 4);
        final toDay = DateTime(2026, 9, 5);

        // Only day 1 and day 4 exist in firestore
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day1)).set(
          createDailyDocMap(revenue: 500.0, ordersCount: 2),
        );
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day4)).set(
          createDailyDocMap(revenue: 1000.0, ordersCount: 4),
        );

        final response = await sut.getAnalytics(from: day1, to: toDay);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.revenueOverTime.length, 5);

        // Day 1 (exists)
        expect(data.revenueOverTime[0].date, DateTime(2026, 9, 1));
        expect(data.revenueOverTime[0].revenue, 500.0);
        expect(data.revenueOverTime[0].ordersCount, 2);

        // Day 2 (missing -> filled with 0)
        expect(data.revenueOverTime[1].date, DateTime(2026, 9, 2));
        expect(data.revenueOverTime[1].revenue, 0.0);
        expect(data.revenueOverTime[1].ordersCount, 0);

        // Day 3 (missing -> filled with 0)
        expect(data.revenueOverTime[2].date, DateTime(2026, 9, 3));
        expect(data.revenueOverTime[2].revenue, 0.0);
        expect(data.revenueOverTime[2].ordersCount, 0);

        // Day 4 (exists)
        expect(data.revenueOverTime[3].date, DateTime(2026, 9, 4));
        expect(data.revenueOverTime[3].revenue, 1000.0);
        expect(data.revenueOverTime[3].ordersCount, 4);

        // Day 5 (missing -> filled with 0)
        expect(data.revenueOverTime[4].date, DateTime(2026, 9, 5));
        expect(data.revenueOverTime[4].revenue, 0.0);
        expect(data.revenueOverTime[4].ordersCount, 0);

        // KPI only sums existing days
        expect(data.kpi.totalRevenue, 1500.0);
        expect(data.kpi.totalOrders, 6);
      });

      test('ignores daily documents strictly outside the requested date range', () async {
        final beforeRange = DateTime(2026, 8, 31);
        final day1 = DateTime(2026, 9, 1);
        final day2 = DateTime(2026, 9, 2);
        final afterRange = DateTime(2026, 9, 10);

        await fakeFirestore.collection(dailyCollection).doc(dateKey(beforeRange)).set(
          createDailyDocMap(revenue: 9999.0, ordersCount: 50),
        );
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day1)).set(
          createDailyDocMap(revenue: 100.0, ordersCount: 1),
        );
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day2)).set(
          createDailyDocMap(revenue: 200.0, ordersCount: 2),
        );
        await fakeFirestore.collection(dailyCollection).doc(dateKey(afterRange)).set(
          createDailyDocMap(revenue: 8888.0, ordersCount: 40),
        );

        final response = await sut.getAnalytics(from: day1, to: day2);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        // Total should only be day1 + day2 = 300.0 and 3 orders
        expect(data.kpi.totalRevenue, 300.0);
        expect(data.kpi.totalOrders, 3);
        expect(data.revenueOverTime.length, 2);
      });

      test('handles month-end and year-end boundary transitions properly', () async {
        // Range across year end: 2026-12-30 to 2027-01-02 (4 days)
        final fromDate = DateTime(2026, 12, 30);
        final toDate = DateTime(2027, 1, 2);

        await fakeFirestore.collection(dailyCollection).doc('2026-12-31').set(
          createDailyDocMap(revenue: 300.0, ordersCount: 3),
        );
        await fakeFirestore.collection(dailyCollection).doc('2027-01-01').set(
          createDailyDocMap(revenue: 700.0, ordersCount: 7),
        );

        final response = await sut.getAnalytics(from: fromDate, to: toDate);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.revenueOverTime.length, 4);
        expect(data.revenueOverTime[0].date, DateTime(2026, 12, 30));
        expect(data.revenueOverTime[0].revenue, 0.0);
        expect(data.revenueOverTime[1].date, DateTime(2026, 12, 31));
        expect(data.revenueOverTime[1].revenue, 300.0);
        expect(data.revenueOverTime[2].date, DateTime(2027, 1, 1));
        expect(data.revenueOverTime[2].revenue, 700.0);
        expect(data.revenueOverTime[3].date, DateTime(2027, 1, 2));
        expect(data.revenueOverTime[3].revenue, 0.0);

        expect(data.kpi.totalRevenue, 1000.0);
        expect(data.kpi.totalOrders, 10);
      });

      test('accurately counts totalUsers, verifiedUsers, and activeCartsCount', () async {
        // User 1: verified + active cart
        await addUser(uid: 'u1', isVerified: true, cartItems: [{'productId': 'p1', 'quantity': 1}]);
        // User 2: verified + no cart
        await addUser(uid: 'u2', isVerified: true);
        // User 3: unverified + active cart
        await addUser(uid: 'u3', isVerified: false, cartItems: [{'productId': 'p2', 'quantity': 2}]);
        // User 4: unverified + no cart
        await addUser(uid: 'u4', isVerified: false);
        // User 5: unverified + no cart
        await addUser(uid: 'u5', isVerified: false);

        final day = DateTime(2026, 9, 20);
        final response = await sut.getAnalytics(from: day, to: day);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.kpi.totalUsers, 5);
        expect(data.kpi.verifiedUsers, 2);
        expect(data.kpi.activeCartsCount, 2);
      });

      test('aggregates product quantities and revenues across multiple days and sorts descending by quantitySold', () async {
        final day1 = DateTime(2026, 9, 1);
        final day2 = DateTime(2026, 9, 2);

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day1)).set(
          createDailyDocMap(
            products: {
              'apple': {
                'name': 'Apple',
                'imagePath': 'apple.png',
                'quantitySold': 5,
                'revenue': 50.0,
              },
              'banana': {
                'name': 'Banana',
                'imagePath': 'banana.png',
                'quantitySold': 2,
                'revenue': 20.0,
              },
            },
          ),
        );

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day2)).set(
          createDailyDocMap(
            products: {
              'apple': {
                'name': 'Apple',
                'imagePath': 'apple.png',
                'quantitySold': 10,
                'revenue': 100.0,
              },
              'orange': {
                'name': 'Orange',
                'imagePath': 'orange.png',
                'quantitySold': 8,
                'revenue': 40.0,
              },
            },
          ),
        );

        final response = await sut.getAnalytics(from: day1, to: day2);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.topProducts.length, 3);

        // Apple: 5 + 10 = 15 qty, 50 + 100 = 150 rev (Rank 1)
        expect(data.topProducts[0].code, 'apple');
        expect(data.topProducts[0].name, 'Apple');
        expect(data.topProducts[0].imagePath, 'apple.png');
        expect(data.topProducts[0].totalQuantitySold, 15);
        expect(data.topProducts[0].totalRevenue, 150.0);

        // Orange: 8 qty, 40 rev (Rank 2)
        expect(data.topProducts[1].code, 'orange');
        expect(data.topProducts[1].name, 'Orange');
        expect(data.topProducts[1].totalQuantitySold, 8);
        expect(data.topProducts[1].totalRevenue, 40.0);

        // Banana: 2 qty, 20 rev (Rank 3)
        expect(data.topProducts[2].code, 'banana');
        expect(data.topProducts[2].name, 'Banana');
        expect(data.topProducts[2].totalQuantitySold, 2);
        expect(data.topProducts[2].totalRevenue, 20.0);
      });

      test('limits topProducts to top 10 products when more than 10 products are sold', () async {
        final day = DateTime(2026, 9, 1);

        // Create 12 products with quantity sold from 1 to 12
        final productsMap = <String, Map<String, dynamic>>{};
        for (var i = 1; i <= 12; i++) {
          productsMap['prod_$i'] = {
            'name': 'Product $i',
            'imagePath': 'prod_$i.png',
            'quantitySold': i * 10,
            'revenue': i * 100.0,
          };
        }

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day)).set(
          createDailyDocMap(products: productsMap),
        );

        final response = await sut.getAnalytics(from: day, to: day);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        // Top 10 products only
        expect(data.topProducts.length, 10);
        // First should be prod_12 (qty: 120)
        expect(data.topProducts.first.code, 'prod_12');
        expect(data.topProducts.first.totalQuantitySold, 120);
        // Tenth should be prod_3 (qty: 30)
        expect(data.topProducts.last.code, 'prod_3');
        expect(data.topProducts.last.totalQuantitySold, 30);

        // prod_1 (qty 10) and prod_2 (qty 20) must be excluded
        expect(data.topProducts.any((p) => p.code == 'prod_1'), isFalse);
        expect(data.topProducts.any((p) => p.code == 'prod_2'), isFalse);
      });

      test('preserves existing name and imagePath if subsequent daily document omits them for a product', () async {
        final day1 = DateTime(2026, 9, 1);
        final day2 = DateTime(2026, 9, 2);

        await fakeFirestore.collection(dailyCollection).doc(dateKey(day1)).set(
          createDailyDocMap(
            products: {
              'p1': {
                'name': 'Watermelon',
                'imagePath': 'melon.png',
                'quantitySold': 3,
                'revenue': 30.0,
              },
            },
          ),
        );

        // Day 2 has same product code but name and imagePath are null/omitted
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day2)).set(
          createDailyDocMap(
            products: {
              'p1': {
                'quantitySold': 7,
                'revenue': 70.0,
              },
            },
          ),
        );

        final response = await sut.getAnalytics(from: day1, to: day2);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.topProducts.length, 1);
        expect(data.topProducts.first.code, 'p1');
        expect(data.topProducts.first.name, 'Watermelon');
        expect(data.topProducts.first.imagePath, 'melon.png');
        expect(data.topProducts.first.totalQuantitySold, 10);
        expect(data.topProducts.first.totalRevenue, 100.0);
      });

      test('handles daily documents with partially populated statuses and payment methods correctly', () async {
        final day = DateTime(2026, 9, 1);

        // Only deliveredOrders and cancelledOrders are present, paypal is the only payment method
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day)).set(
          createDailyDocMap(
            revenue: 900.0,
            ordersCount: 3,
            orderStatuses: {
              'deliveredOrders': 2,
              'cancelledOrders': 1,
            },
            paymentMethods: {
              'paypal': 3,
            },
          ),
        );

        final response = await sut.getAnalytics(from: day, to: day);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.kpi.deliveredOrders, 2);
        expect(data.kpi.cancelledOrders, 1);
        expect(data.kpi.pendingOrders, 0);
        expect(data.kpi.processingOrders, 0);
        expect(data.kpi.shippedOrders, 0);

        final cashStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.cash);
        final cardStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.card);
        final paypalStat = data.paymentMethodStats.firstWhere((p) => p.type == PaymentMethodType.paypal);

        expect(cashStat.count, 0);
        expect(cardStat.count, 0);
        expect(paypalStat.count, 3);
      });

      test('handles daily documents with null, missing, or malformed fields gracefully', () async {
        final day = DateTime(2026, 9, 5);

        // Completely empty daily document map
        await fakeFirestore.collection(dailyCollection).doc(dateKey(day)).set({
          'revenue': null,
          'ordersCount': null,
          'orderStatuses': null,
          'paymentMethods': null,
          'products': {
            'corrupt_prod': null,
            'valid_prod': {
              'name': null,
              'imagePath': null,
              'quantitySold': null,
              'revenue': null,
            },
          },
        });

        final response = await sut.getAnalytics(from: day, to: day);

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.kpi.totalRevenue, 0.0);
        expect(data.kpi.totalOrders, 0);
        expect(data.revenueOverTime.first.revenue, 0.0);
        expect(data.revenueOverTime.first.ordersCount, 0);

        // Product with null values receives defaults
        expect(data.topProducts.length, 1);
        expect(data.topProducts.first.code, 'valid_prod');
        expect(data.topProducts.first.name, '');
        expect(data.topProducts.first.imagePath, '');
        expect(data.topProducts.first.totalQuantitySold, 0);
        expect(data.topProducts.first.totalRevenue, 0.0);
      });

      test('formats single-digit months and days with leading zeros in dateKey lookup', () async {
        // Date with single-digit month and day: 2026-03-05
        final singleDigitDate = DateTime(2026, 3, 5);

        await fakeFirestore.collection(dailyCollection).doc('2026-03-05').set(
          createDailyDocMap(revenue: 777.0, ordersCount: 7),
        );

        final response = await sut.getAnalytics(
          from: singleDigitDate,
          to: singleDigitDate,
        );

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.kpi.totalRevenue, 777.0);
        expect(data.kpi.totalOrders, 7);
        expect(data.revenueOverTime.first.revenue, 777.0);
      });

      test('normalizes DateTime instances with non-zero time components', () async {
        // from at 14:30, to at 08:15 across 2 days
        final fromWithTime = DateTime(2026, 9, 1, 14, 30);
        final toWithTime = DateTime(2026, 9, 2, 8, 15);

        await fakeFirestore.collection(dailyCollection).doc('2026-09-01').set(
          createDailyDocMap(revenue: 100.0, ordersCount: 1),
        );
        await fakeFirestore.collection(dailyCollection).doc('2026-09-02').set(
          createDailyDocMap(revenue: 200.0, ordersCount: 2),
        );

        final response = await sut.getAnalytics(
          from: fromWithTime,
          to: toWithTime,
        );

        expect(response, isA<NetworkSuccess<AnalyticsDataModel>>());
        final data = (response as NetworkSuccess<AnalyticsDataModel>).data!;

        expect(data.revenueOverTime.length, 2);
        expect(data.kpi.totalRevenue, 300.0);
        expect(data.kpi.totalOrders, 3);
      });
    });
  });
}
