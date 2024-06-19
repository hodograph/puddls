// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drive _$DriveFromJson(Map<String, dynamic> json) => Drive(
      driver: json['driver'] as String,
      originLat: (json['originLat'] as num).toDouble(),
      originLng: (json['originLng'] as num).toDouble(),
      destinationLat: (json['destinationLat'] as num).toDouble(),
      destinationLng: (json['destinationLng'] as num).toDouble(),
      tripTime: DateTime.parse(json['tripTime'] as String),
      personalItems: (json['personalItems'] as num).toInt(),
      carryOns: (json['carryOns'] as num).toInt(),
      checkedBags: (json['checkedBags'] as num).toInt(),
      passengers: (json['passengers'] as num).toInt(),
    );

Map<String, dynamic> _$DriveToJson(Drive instance) => <String, dynamic>{
      'driver': instance.driver,
      'originLat': instance.originLat,
      'originLng': instance.originLng,
      'destinationLat': instance.destinationLat,
      'destinationLng': instance.destinationLng,
      'tripTime': instance.tripTime.toIso8601String(),
      'personalItems': instance.personalItems,
      'carryOns': instance.carryOns,
      'checkedBags': instance.checkedBags,
      'passengers': instance.passengers,
    };
