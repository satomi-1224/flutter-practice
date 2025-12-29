import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_app/features/order/models/order.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app/infra/api/api_client.dart';

part 'order_api_client.g.dart';

@RestApi()
abstract class OrderApiClient {
  factory OrderApiClient(Dio dio, {String baseUrl}) = _OrderApiClient;

  @GET('/orders')
  Future<List<Order>> fetchOrders();

  @GET('/orders/{id}')
  Future<Order> fetchOrder(@Path('id') int id);

  @POST('/orders')
  Future<void> createOrder(@Body() Order order);
}

@Riverpod(keepAlive: true)
OrderApiClient orderApiClient(Ref ref) {
  return OrderApiClient(ref.read(dioProvider));
}
