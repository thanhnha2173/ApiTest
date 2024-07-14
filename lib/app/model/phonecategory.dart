import 'dart:convert';
import 'package:flutter/material.dart';

class PhoneCategory {
  final int id;
  final String name;
  String description;
  String imageUrl;

  PhoneCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory PhoneCategory.fromJson(Map<String, dynamic> json) {
    return PhoneCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}