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

  @HiveField(5)
  String? workspaceId; // Workspace this category belongs to (nullable for local categories)

  @HiveField(6)
  DateTime? createdAt; // Creation timestamp

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.isPredefined = false,
    this.workspaceId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Method to generate a unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Convert color int back to Color
  Color get colorValue => Color(color);

  // Set color from Color object
  set colorValue(Color value) => color = value.value;

  // Convert Category to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'isPredefined': isPredefined,
      'workspaceId': workspaceId,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create Category from Firestore Map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: map['icon'] as String,
      color: map['color'] as int,
      isPredefined: map['isPredefined'] as bool? ?? false,
      workspaceId: map['workspaceId'] as String?,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : null,
    );
  }

  // Copy with updated fields
  Category copyWith({
    String? id,
    String? name,
    String? icon,
    int? color,
    bool? isPredefined,
    String? workspaceId,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isPredefined: isPredefined ?? this.isPredefined,
      workspaceId: workspaceId ?? this.workspaceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

