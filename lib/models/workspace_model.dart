import 'dart:math';

class WorkspaceModel {
  final String id;
  final String name;
  final String type; // 'personal' or 'shared'
  final String createdBy;
  final List<String> members;
  final String inviteCode;
  final DateTime createdAt;
  final String icon;
  final String color;

  WorkspaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdBy,
    required this.members,
    required this.inviteCode,
    required this.createdAt,
    this.icon = '📋',
    this.color = '6C63FF',
  });

  // Generate a unique 6-character invite code
  static String generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Excluding similar chars
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Generate a unique workspace ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdBy': createdBy,
      'members': members,
      'inviteCode': inviteCode,
      'createdAt': createdAt.toIso8601String(),
      'icon': icon,
      'color': color,
    };
  }

  // Create from Firestore Map
  factory WorkspaceModel.fromMap(Map<String, dynamic> map) {
    return WorkspaceModel(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      createdBy: map['createdBy'] as String,
      members: List<String>.from(map['members'] as List),
      inviteCode: map['inviteCode'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      icon: map['icon'] as String? ?? '📋',
      color: map['color'] as String? ?? '6C63FF',
    );
  }

  // Copy with updated fields
  WorkspaceModel copyWith({
    String? id,
    String? name,
    String? type,
    String? createdBy,
    List<String>? members,
    String? inviteCode,
    DateTime? createdAt,
    String? icon,
    String? color,
  }) {
    return WorkspaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  // Check if user is member
  bool isMember(String userId) {
    return members.contains(userId);
  }

  // Check if user is creator
  bool isCreator(String userId) {
    return createdBy == userId;
  }
}

