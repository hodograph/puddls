import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User 
{
  String? displayName;
  final String email;
  final String id;
  String? picture;

  User({required this.displayName, required this.email, required this.id, required this.picture});

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) => User.fromJson(snapshot.data()!);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}