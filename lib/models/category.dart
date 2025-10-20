import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart'; // This file will generate automatically

@HiveType(typeId: 1)
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String icon; // Emoji or icon identifier

  @HiveField(3)
  int color; // Color value as int

  @HiveField(4)
  bool isPredefined; // To distinguish predefined from custom categories

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isPredefined = false,
  });

  // Method to generate a unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Convert color int back to Color
  Color get colorValue => Color(color);

  // Set color from Color object
  set colorValue(Color value) => color = value.value;
}

