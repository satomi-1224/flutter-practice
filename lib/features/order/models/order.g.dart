// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: (json['id'] as num).toInt(),
  itemTitle: json['itemTitle'] as String,
  totalAmount: (json['totalAmount'] as num).toInt(),
  orderedAt: DateTime.parse(json['orderedAt'] as String),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'itemTitle': instance.itemTitle,
  'totalAmount': instance.totalAmount,
  'orderedAt': instance.orderedAt.toIso8601String(),
};
