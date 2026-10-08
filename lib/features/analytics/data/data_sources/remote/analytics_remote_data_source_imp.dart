import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruit_hub_dashboard/core/enums/order_status.dart';
import 'package:fruit_hub_dashboard/core/helpers/app_logger.dart';
import 'package:fruit_hub_dashboard/core/helpers/backend_endpoints.dart';
import 'package:fruit_hub_dashboard/core/network/api_helper.dart';
import 'package:fruit_hub_dashboard/core/network/network_response.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/data_sources/remote/analytics_remote_data_source.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_data_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/analytics_kpi_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/order_status_stat_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/payment_method_stat_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/revenue_data_point_model.dart';
import 'package:fruit_hub_dashboard/features/analytics/data/models/top_product_model.dart';

class AnalyticsRemoteDataSourceImp implements AnalyticsRemoteDataSource {
  AnalyticsRemoteDataSourceImp({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  @override
  Future<NetworkResponse<AnalyticsDataModel>> getAnalytics({
    required DateTime from,
    required DateTime to,
  }) => ApiHelper.executeSafely(() async {
    // ── 1. Fetch users stats (counts only) ───────────────────────────
    final userStatsResults = await Future.wait([
      _firestore.collection(BackendEndpoints.usersCollection).count().get(),
      _firestore
          .collection(BackendEndpoints.usersCollection)
          .where('isVerified', isEqualTo: true)
          .count()
          .get(),
      _firestore
          .collection(BackendEndpoints.usersCollection)
          .where('cartItems', isNotEqualTo: [])
          .count()
          .get(),
    ]);

    final totalUsers = userStatsResults[0].count ?? 0;
    final verifiedUsers = userStatsResults[1].count ?? 0;
    final activeCartsCount = userStatsResults[2].count ?? 0;

    // ── 2. Query analytics_daily collection for the date range ──────
    final fromKey = _dateKey(from);
    final toKey = _dateKey(to);

    final dailySnap = await _firestore
        .collection(BackendEndpoints.analyticsDailyCollection)
        .where(FieldPath.documentId, isGreaterThanOrEqualTo: fromKey)
        .where(FieldPath.documentId, isLessThanOrEqualTo: toKey)
        .orderBy(FieldPath.documentId)
        .get();

    // Map existing Firestore daily docs by date string 'YYYY-MM-DD'
    final dailyDocsMap = <String, Map<String, dynamic>>{
      for (final doc in dailySnap.docs) doc.id: doc.data(),
    };

    // ── 3. Build continuous day-by-day revenue timeline ─────────────
    // Fill every single calendar day between 'from' and 'to' (inclusive),
    // even if there were zero orders / no Firestore document for that day.
    final revenueOverTime = <RevenueDataPointModel>[];
    double rangeTotalRevenue = 0.0;
    int rangeTotalOrders = 0;

    // Daily breakdown maps for statuses and payment methods
    final rangeStatusCounts = <OrderStatus, int>{
      for (final s in OrderStatus.values) s: 0,
    };
    final rangePaymentCounts = <String, int>{
      'cash_on_delivery': 0,
      'credit_card': 0,
      'paypal': 0,
    };

    final startDate = DateTime(from.year, from.month, from.day);
    final endDate = DateTime(to.year, to.month, to.day);
    final daysCount = endDate.difference(startDate).inDays;

    for (var i = 0; i <= daysCount; i++) {
      final currentDay = startDate.add(Duration(days: i));
      final dayKey = _dateKey(currentDay);
      final dayData = dailyDocsMap[dayKey];

      if (dayData != null) {
        final rev = (dayData['revenue'] as num?)?.toDouble() ?? 0.0;
        final orders = (dayData['ordersCount'] as num?)?.toInt() ?? 0;
        rangeTotalRevenue += rev;
        rangeTotalOrders += orders;

        revenueOverTime.add(
          RevenueDataPointModel(
            date: currentDay,
            revenue: rev,
            ordersCount: orders,
          ),
        );

        // Aggregate order statuses if present in daily document (nested or flattened dot keys)
        final dailyStatuses = _extractOrderStatuses(dayData);
        if (dailyStatuses.isNotEmpty) {
          for (final status in OrderStatus.values) {
            final fieldName = '${status.name}Orders';
            final c = (dailyStatuses[fieldName] as num?)?.toInt() ?? 0;
            rangeStatusCounts[status] = (rangeStatusCounts[status] ?? 0) + c;
          }
        }

        // Aggregate payment methods if present in daily document (nested or flattened dot keys)
        final dailyPayments = _extractPaymentMethods(dayData);
        if (dailyPayments.isNotEmpty) {
          for (final entry in dailyPayments.entries) {
            final count = (entry.value as num?)?.toInt() ?? 0;
            rangePaymentCounts[entry.key] =
                (rangePaymentCounts[entry.key] ?? 0) + count;
          }
        }
      } else {
        // Zero-sales day
        revenueOverTime.add(
          RevenueDataPointModel(date: currentDay, revenue: 0.0, ordersCount: 0),
        );
      }
    }

    // ── 6. Aggregate top products directly from daily documents ─────
    final productMap =
        <String, ({String name, String imagePath, int qty, double rev})>{};

    for (final dayDoc in dailySnap.docs) {
      final dayData = dayDoc.data();
      final products = _extractProducts(dayData);
      if (products.isEmpty) continue;

      for (final entry in products.entries) {
        final p = entry.value;
        final code = entry.key;
        final qty = (p['quantitySold'] as num?)?.toInt() ?? 0;
        final rev = (p['revenue'] as num?)?.toDouble() ?? 0.0;
        final current = productMap[code];
        productMap[code] = (
          name: p['name'] as String? ?? current?.name ?? '',
          imagePath: p['imagePath'] as String? ?? current?.imagePath ?? '',
          qty: (current?.qty ?? 0) + qty,
          rev: (current?.rev ?? 0.0) + rev,
        );
      }
    }

    final topProducts =
        (productMap.entries.toList()..sort((a, b) {
              final qtyComparison = b.value.qty.compareTo(a.value.qty);
              if (qtyComparison != 0) return qtyComparison;
              return b.value.rev.compareTo(a.value.rev);
            }))
            .take(10)
            .map(
              (e) => TopProductModel(
                code: e.key,
                name: e.value.name,
                imagePath: e.value.imagePath,
                totalQuantitySold: e.value.qty,
                totalRevenue: e.value.rev,
              ),
            )
            .toList();

    // ── 7. Build order status stats for the selected range ─────────
    final orderStatusStats = OrderStatus.values
        .map(
          (status) => OrderStatusStatModel(
            status: status,
            count: rangeStatusCounts[status] ?? 0,
          ),
        )
        .toList();

    // ── 8. Build payment method stats for the selected range ────────
    final paymentMethodStats = PaymentMethodStatModel.listFromSummaryMap(
      rangePaymentCounts,
    );

    // ── 9. Scoped KPI for the selected date range ────────────────────
    final kpi = AnalyticsKpiModel(
      totalRevenue: rangeTotalRevenue,
      totalOrders: rangeTotalOrders,
      deliveredOrders: rangeStatusCounts[OrderStatus.delivered] ?? 0,
      cancelledOrders: rangeStatusCounts[OrderStatus.cancelled] ?? 0,
      pendingOrders: rangeStatusCounts[OrderStatus.pending] ?? 0,
      processingOrders: rangeStatusCounts[OrderStatus.processing] ?? 0,
      shippedOrders: rangeStatusCounts[OrderStatus.shipped] ?? 0,
      totalUsers: totalUsers,
      verifiedUsers: verifiedUsers,
      activeCartsCount: activeCartsCount,
    );

    AppLogger.info(
      'Analytics fetched: ${revenueOverTime.length} days generated in range '
      '[$fromKey → $toKey] (existing docs: ${dailySnap.docs.length})',
    );

    return AnalyticsDataModel(
      kpi: kpi,
      revenueOverTime: revenueOverTime,
      topProducts: topProducts,
      orderStatusStats: orderStatusStats,
      paymentMethodStats: paymentMethodStats,
    );
  }, functionName: 'getAnalytics');

  // ── Helpers ────────────────────────────────────────────────────────────

  /// Returns a YYYY-MM-DD string for Firestore document ID lookup.
  String _dateKey(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-'
      '${dt.month.toString().padLeft(2, '0')}-'
      '${dt.day.toString().padLeft(2, '0')}';

  /// Extracts order statuses supporting both nested map and flat dot-notation keys.
  Map<String, dynamic> _extractOrderStatuses(Map<String, dynamic> dayData) {
    final result = <String, dynamic>{};
    final nested = dayData['orderStatuses'] as Map<String, dynamic>?;
    if (nested != null) {
      result.addAll(nested);
    }
    for (final entry in dayData.entries) {
      if (entry.key.startsWith('orderStatuses.')) {
        final subKey = entry.key.substring('orderStatuses.'.length);
        result[subKey] = entry.value;
      }
    }
    return result;
  }

  /// Extracts payment methods supporting both nested map and flat dot-notation keys.
  Map<String, dynamic> _extractPaymentMethods(Map<String, dynamic> dayData) {
    final result = <String, dynamic>{};
    final nested = dayData['paymentMethods'] as Map<String, dynamic>?;
    if (nested != null) {
      result.addAll(nested);
    }
    for (final entry in dayData.entries) {
      if (entry.key.startsWith('paymentMethods.')) {
        final subKey = entry.key.substring('paymentMethods.'.length);
        result[subKey] = entry.value;
      }
    }
    return result;
  }

  /// Extracts products supporting both nested map and flat dot-notation keys.
  Map<String, Map<String, dynamic>> _extractProducts(
    Map<String, dynamic> dayData,
  ) {
    final result = <String, Map<String, dynamic>>{};
    final nested = dayData['products'] as Map<String, dynamic>?;
    if (nested != null) {
      for (final entry in nested.entries) {
        if (entry.value is Map) {
          result[entry.key] = Map<String, dynamic>.from(entry.value as Map);
        }
      }
    }
    for (final entry in dayData.entries) {
      if (entry.key.startsWith('products.')) {
        final parts = entry.key.split('.');
        if (parts.length >= 3) {
          final code = parts[1];
          final field = parts.sublist(2).join('.');
          result.putIfAbsent(code, () => <String, dynamic>{})[field] =
              entry.value;
        }
      }
    }
    return result;
  }
}
