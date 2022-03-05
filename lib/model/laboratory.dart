import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Laboratory {
  String? name;
  GeoPoint location;

  Laboratory({required this.name, this.location = const GeoPoint(0.5, 0.5)});

  factory Laboratory.fromJson(Map<String, dynamic> json) => Laboratory(
      name: json["name"],
      location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "location": location,
  };
}