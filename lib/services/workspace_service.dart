import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workspace_model.dart';
import '../models/user_model.dart';

class WorkspaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a new workspace
  Future<WorkspaceModel> createWorkspace({
    required String name,
    required String type,
    required String userId,
    String? icon,
    String? color,
  }) async {
    try {
      final workspace = WorkspaceModel(
        id: WorkspaceModel.generateId(),
        name: name,
        type: type,
        createdBy: userId,
        members: [userId],
        inviteCode: WorkspaceModel.generateInviteCode(),
        createdAt: DateTime.now(),
        icon: icon ?? (type == 'personal' ? '👤' : '👥'),
        color: color ?? '6C63FF',
      );

      await _firestore
          .collection('workspaces')
          .doc(workspace.id)
          .set(workspace.toMap());

      return workspace;
    } catch (e) {
      print('Error creating workspace: $e');
      rethrow;
    }
  }

  // Join workspace by invite code
  Future<WorkspaceModel?> joinWorkspaceByCode({
    required String code,
    required String userId,
  }) async {
    try {
      // Find workspace with this invite code
      final querySnapshot = await _firestore
          .collection('workspaces')
          .where('inviteCode', isEqualTo: code.toUpperCase())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Código de invitación no válido');
      }

      final workspaceDoc = querySnapshot.docs.first;
      final workspace = WorkspaceModel.fromMap(workspaceDoc.data());

      // Check if user is already a member
      if (workspace.members.contains(userId)) {
        throw Exception('Ya eres miembro de este workspace');
      }

      // Add user to members
      await _firestore.collection('workspaces').doc(workspace.id).update({
        'members': FieldValue.arrayUnion([userId]),
      });

      return workspace.copyWith(
        members: [...workspace.members, userId],
      );
    } catch (e) {
      print('Error joining workspace: $e');
      rethrow;
    }
  }

  // Get all workspaces for a user
  Stream<List<WorkspaceModel>> getUserWorkspaces(String userId) {
    return _firestore
        .collection('workspaces')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => WorkspaceModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Get workspace by ID
  Future<WorkspaceModel?> getWorkspace(String workspaceId) async {
    try {
      final doc = await _firestore
          .collection('workspaces')
          .doc(workspaceId)
          .get();
      
      if (doc.exists && doc.data() != null) {
        return WorkspaceModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting workspace: $e');
      return null;
    }
  }

  // Get workspace members details
  Future<List<UserModel>> getWorkspaceMembers(String workspaceId) async {
    try {
      final workspace = await getWorkspace(workspaceId);
      if (workspace == null) return [];

      final members = <UserModel>[];
      for (final memberId in workspace.members) {
        final userDoc = await _firestore
            .collection('users')
            .doc(memberId)
            .get();
        
        if (userDoc.exists && userDoc.data() != null) {
          members.add(UserModel.fromMap(userDoc.data()!));
        }
      }

      return members;
    } catch (e) {
      print('Error getting workspace members: $e');
      return [];
    }
  }

  // Leave workspace
  Future<void> leaveWorkspace({
    required String workspaceId,
    required String userId,
  }) async {
    try {
      final workspace = await getWorkspace(workspaceId);
      if (workspace == null) {
        throw Exception('Workspace no encontrado');
      }

      // Check if user is the only member
      if (workspace.members.length == 1 && workspace.members.contains(userId)) {
        // Delete the workspace if it's the last member
        await _firestore.collection('workspaces').doc(workspaceId).delete();
      } else {
        // Remove user from members
        await _firestore.collection('workspaces').doc(workspaceId).update({
          'members': FieldValue.arrayRemove([userId]),
        });
      }
    } catch (e) {
      print('Error leaving workspace: $e');
      rethrow;
    }
  }

  // Delete workspace (only creator can delete)
  Future<void> deleteWorkspace({
    required String workspaceId,
    required String userId,
  }) async {
    try {
      final workspace = await getWorkspace(workspaceId);
      if (workspace == null) {
        throw Exception('Workspace no encontrado');
      }

      if (workspace.createdBy != userId) {
        throw Exception('Solo el creador puede eliminar el workspace');
      }

      await _firestore.collection('workspaces').doc(workspaceId).delete();
    } catch (e) {
      print('Error deleting workspace: $e');
      rethrow;
    }
  }

  // Update workspace
  Future<void> updateWorkspace({
    required String workspaceId,
    String? name,
    String? icon,
    String? color,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (icon != null) updates['icon'] = icon;
      if (color != null) updates['color'] = color;

      if (updates.isNotEmpty) {
        await _firestore
            .collection('workspaces')
            .doc(workspaceId)
            .update(updates);
      }
    } catch (e) {
      print('Error updating workspace: $e');
      rethrow;
    }
  }

  // Generate new invite code for workspace
  Future<String> regenerateInviteCode(String workspaceId) async {
    try {
      final newCode = WorkspaceModel.generateInviteCode();
      await _firestore.collection('workspaces').doc(workspaceId).update({
        'inviteCode': newCode,
      });
      return newCode;
    } catch (e) {
      print('Error regenerating invite code: $e');
      rethrow;
    }
  }
}

