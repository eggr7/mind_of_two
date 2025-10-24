import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import '../services/workspace_service.dart';
import '../models/workspace_model.dart';
import '../models/user_model.dart';

class WorkspaceProvider with ChangeNotifier {
  final WorkspaceService _workspaceService = WorkspaceService();
  
  List<WorkspaceModel> _workspaces = [];
  WorkspaceModel? _activeWorkspace;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _workspacesSubscription;

  List<WorkspaceModel> get workspaces => _workspaces;
  WorkspaceModel? get activeWorkspace => _activeWorkspace;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasWorkspace => _activeWorkspace != null;

  // Initialize workspace provider
  void initialize(String userId) {
    debugPrint('📁 WorkspaceProvider: Initializing for user: $userId');
    _loadActiveWorkspaceFromSettings();
    _listenToWorkspaces(userId);
  }

  // Listen to workspace changes
  void _listenToWorkspaces(String userId) {
    _workspacesSubscription?.cancel();
    _workspacesSubscription = _workspaceService.getUserWorkspaces(userId).listen(
      (workspaces) {
        debugPrint('📁 WorkspaceProvider: Received ${workspaces.length} workspaces');
        _workspaces = workspaces;
        
        // If no active workspace and we have workspaces, set the first one as active
        if (_activeWorkspace == null && workspaces.isNotEmpty) {
          debugPrint('📁 WorkspaceProvider: Auto-selecting first workspace: ${workspaces.first.name}');
          setActiveWorkspace(workspaces.first);
        }
        
        // If active workspace was deleted, clear it
        if (_activeWorkspace != null && 
            !workspaces.any((w) => w.id == _activeWorkspace!.id)) {
          debugPrint('📁 WorkspaceProvider: Active workspace deleted, clearing');
          _activeWorkspace = null;
          _saveActiveWorkspaceToSettings(null);
        }
        
        notifyListeners();
      },
      onError: (error) {
        debugPrint('📁 WorkspaceProvider: Error: $error');
        _errorMessage = 'Error al cargar workspaces: $error';
        notifyListeners();
      },
    );
  }

  // Create workspace
  Future<WorkspaceModel?> createWorkspace({
    required String name,
    required String type,
    required String userId,
    String? icon,
    String? color,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final workspace = await _workspaceService.createWorkspace(
        name: name,
        type: type,
        userId: userId,
        icon: icon,
        color: color,
      );

      // Set as active workspace
      await setActiveWorkspace(workspace);

      _isLoading = false;
      notifyListeners();
      return workspace;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al crear workspace: $e';
      notifyListeners();
      return null;
    }
  }

  // Join workspace by code
  Future<WorkspaceModel?> joinWorkspace({
    required String code,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final workspace = await _workspaceService.joinWorkspaceByCode(
        code: code,
        userId: userId,
      );

      if (workspace != null) {
        // Set as active workspace
        await setActiveWorkspace(workspace);
      }

      _isLoading = false;
      notifyListeners();
      return workspace;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  // Set active workspace
  Future<void> setActiveWorkspace(WorkspaceModel workspace) async {
    _activeWorkspace = workspace;
    await _saveActiveWorkspaceToSettings(workspace.id);
    notifyListeners();
  }

  // Leave workspace
  Future<bool> leaveWorkspace({
    required String workspaceId,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _workspaceService.leaveWorkspace(
        workspaceId: workspaceId,
        userId: userId,
      );

      // Clear active workspace if it was the one we left
      if (_activeWorkspace?.id == workspaceId) {
        _activeWorkspace = null;
        await _saveActiveWorkspaceToSettings(null);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al salir del workspace: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete workspace
  Future<bool> deleteWorkspace({
    required String workspaceId,
    required String userId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _workspaceService.deleteWorkspace(
        workspaceId: workspaceId,
        userId: userId,
      );

      // Clear active workspace if it was the one we deleted
      if (_activeWorkspace?.id == workspaceId) {
        _activeWorkspace = null;
        await _saveActiveWorkspaceToSettings(null);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // Get workspace members
  Future<List<UserModel>> getWorkspaceMembers(String workspaceId) async {
    try {
      return await _workspaceService.getWorkspaceMembers(workspaceId);
    } catch (e) {
      debugPrint('Error getting workspace members: $e');
      return [];
    }
  }

  // Update workspace
  Future<bool> updateWorkspace({
    required String workspaceId,
    String? name,
    String? icon,
    String? color,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _workspaceService.updateWorkspace(
        workspaceId: workspaceId,
        name: name,
        icon: icon,
        color: color,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error al actualizar workspace: $e';
      notifyListeners();
      return false;
    }
  }

  // Regenerate invite code
  Future<String?> regenerateInviteCode(String workspaceId) async {
    try {
      final newCode = await _workspaceService.regenerateInviteCode(workspaceId);
      notifyListeners();
      return newCode;
    } catch (e) {
      _errorMessage = 'Error al regenerar código: $e';
      notifyListeners();
      return null;
    }
  }

  // Save active workspace ID to Hive settings
  Future<void> _saveActiveWorkspaceToSettings(String? workspaceId) async {
    try {
      final settingsBox = Hive.box<dynamic>('settings');
      await settingsBox.put('activeWorkspaceId', workspaceId);
    } catch (e) {
      debugPrint('Error saving active workspace: $e');
    }
  }

  // Load active workspace ID from Hive settings
  void _loadActiveWorkspaceFromSettings() {
    try {
      final settingsBox = Hive.box<dynamic>('settings');
      final workspaceId = settingsBox.get('activeWorkspaceId') as String?;
      
      if (workspaceId != null) {
        // Will be set when workspaces are loaded
        debugPrint('Saved active workspace ID: $workspaceId');
      }
    } catch (e) {
      debugPrint('Error loading active workspace: $e');
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _workspacesSubscription?.cancel();
    super.dispose();
  }
}

