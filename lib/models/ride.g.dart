// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ride.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ride _$RideFromJson(Map<String, dynamic> json) => Ride(
      rider: json['rider'] as String,
      originLat: (json['originLat'] as num).toDouble(),
      originLng: (json['originLng'] as num).toDouble(),
      destinationLat: (json['destinationLat'] as num).toDouble(),
      destinationLng: (json['destinationLng'] as num).toDouble(),
      startPickupRange: DateTime.parse(json['startPickupRange'] as String),
      endPickupRange: DateTime.parse(json['endPickupRange'] as String),
      personalItems: (json['personalItems'] as num).toInt(),
      carryOns: (json['carryOns'] as num).toInt(),
      checkedBags: (json['checkedBags'] as num).toInt(),
      passengers: (json['passengers'] as num).toInt(),
    );

Map<String, dynamic> _$RideToJson(Ride instance) => <String, dynamic>{
      'rider': instance.rider,
      'originLat': instance.originLat,
      'originLng': instance.originLng,
      'destinationLat': instance.destinationLat,
      'destinationLng': instance.destinationLng,
      'startPickupRange': instance.startPickupRange.toIso8601String(),
      'endPickupRange': instance.endPickupRange.toIso8601String(),
      'personalItems': instance.personalItems,
      'carryOns': instance.carryOns,
      'checkedBags': instance.checkedBags,
      'passengers': instance.passengers,
    };
