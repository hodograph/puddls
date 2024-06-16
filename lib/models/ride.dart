import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'ride.g.dart';

@JsonSerializable()
class Ride
{
  final String rider;
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final DateTime startPickupRange;
  final DateTime endPickupRange;

  const Ride({required this.rider,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.startPickupRange,
    required this.endPickupRange});

  factory Ride.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) => Ride.fromJson(snapshot.data()!);

  factory Ride.fromJson(Map<String, dynamic> json) => _$RideFromJson(json);

  Map<String, dynamic> toJson() => _$RideToJson(this);
}