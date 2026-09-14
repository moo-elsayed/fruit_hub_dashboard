import 'package:equatable/equatable.dart';

import '../../../../core/enums/payment_methods.dart';

class PaymentMethodStatEntity extends Equatable {
  const PaymentMethodStatEntity({required this.type, required this.count});

  final PaymentMethodType type;
  final int count;

  @override
  List<Object?> get props => [type, count];
}
