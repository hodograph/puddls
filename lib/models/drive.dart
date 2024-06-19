import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'drive.g.dart';

@JsonSerializable()
class Drive
{
  final String driver;
  final double originLat;
  final double originLng;
  final double destinationLat;
  final double destinationLng;
  final DateTime tripTime;
  final int personalItems;
  final int carryOns;
  final int checkedBags;
  final int passengers;
  final List<String> rides;
  final List<String> matches;

  const Drive({required this.driver,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.tripTime,
    required this.personalItems,
    required this.carryOns,
    required this.checkedBags,
    required this.passengers,
    this.rides = const <String>[],
    this.matches = const <String> []});

  factory Drive.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) => Drive.fromJson(snapshot.data()!);

  factory Drive.fromJson(Map<String, dynamic> json) => _$DriveFromJson(json);

  Map<String, dynamic> toJson() => _$DriveToJson(this);
}