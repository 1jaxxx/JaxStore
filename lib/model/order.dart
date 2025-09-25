// lib/model/order.dart
import 'paket_jasa.dart';

class Order {
  final String orderId;
  final PaketJasa paket;
  final DateTime orderDate;
  final String status;
  final int? stars;

  Order({
    required this.orderId,
    required this.paket,
    required this.orderDate,
    this.status = "Dalam Proses",
    this.stars,
  });
}