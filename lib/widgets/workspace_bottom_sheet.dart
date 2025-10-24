import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';
import '../providers/task_provider.dart';
import '../providers/category_provider.dart';
import '../providers/auth_provider.dart';
import '../models/workspace_model.dart';
import '../screens/workspace/create_workspace_screen.dart';
import '../screens/workspace/join_workspace_screen.dart';

/// Bottom sheet that displays all available workspaces and allows switching between them
class WorkspaceBottomSheet extends StatefulWidget {
  const WorkspaceBottomSheet({super.key});

  @override
  State<WorkspaceBottomSheet> createState() => _WorkspaceBottomSheetState();
}

class _WorkspaceBottomSheetState extends State<WorkspaceBottomSheet> {
  bool _isSwitching = false;

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final workspaces = workspaceProvider.workspaces;
    final activeWorkspace = workspaceProvider.activeWorkspace;
    
    final personalWorkspaces = workspaces.where((w) => w.type == 'personal').toList();
    final sharedWorkspaces = workspaces.where((w) => w.type == 'shared').toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Switch Workspace',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Loading indicator
          if (_isSwitching)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Switching workspace...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          
          // Workspaces list
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shared workspaces
                  if (sharedWorkspaces.isNotEmpty) ...[
                    _buildSectionHeader(context, 'Shared', Icons.people),
                    const SizedBox(height: 8),
                    ...sharedWorkspaces.map((workspace) => _buildWorkspaceTile(
                      context,
                      workspace,
                      activeWorkspace,
                      workspaceProvider,
                      taskProvider,
                      categoryProvider,
                      authProvider,
                    )),
                    const SizedBox(height: 16),
                  ],
                  
                  // Personal workspaces
                  if (personalWorkspaces.isNotEmpty) ...[
                    _buildSectionHeader(context, 'Personal', Icons.person),
                    const SizedBox(height: 8),
                    ...personalWorkspaces.map((workspace) => _buildWorkspaceTile(
                      context,
                      workspace,
                      activeWorkspace,
                      workspaceProvider,
                      taskProvider,
                      categoryProvider,
                      authProvider,
                    )),
                  ],
                ],
              ),
            ),
          ),
          
          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSwitching ? null : () {
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const JoinWorkspaceScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.group_add),
                    label: const Text('Join Workspace'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSwitching ? null : () {
                      Navigator.pop(context);
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => const CreateWorkspaceScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create New'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTile(
    BuildContext context,
    WorkspaceModel workspace,
    WorkspaceModel? activeWorkspace,
    WorkspaceProvider workspaceProvider,
    TaskProvider taskProvider,
    CategoryProvider categoryProvider,
    AuthProvider authProvider,
  ) {
    final isActive = workspace.id == activeWorkspace?.id;
    final workspaceColor = _getWorkspaceColor(workspace.color);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isActive
            ? workspaceColor.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isActive || _isSwitching
              ? null
              : () async {
                  setState(() => _isSwitching = true);
                  
                  await workspaceProvider.setActiveWorkspace(workspace);
                  
                  // Connect TaskProvider and CategoryProvider to new workspace
                  final userId = authProvider.currentUser?.uid;
                  if (userId != null) {
                    taskProvider.setActiveWorkspace(workspace.id, userId);
                    categoryProvider.setActiveWorkspace(workspace.id);
                    debugPrint('🔄 Switched providers to workspace: ${workspace.id}');
                  }
                  
                  if (mounted) {
                    setState(() => _isSwitching = false);
                    
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Text(workspace.icon),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Switched to "${workspace.name}"',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? workspaceColor.withOpacity(0.5)
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                width: isActive ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Workspace icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: workspaceColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      workspace.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Workspace info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workspace.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            workspace.type == 'shared' ? Icons.people : Icons.person,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${workspace.members.length} member${workspace.members.length != 1 ? 's' : ''}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Active indicator
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: workspaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getWorkspaceColor(String colorHex) {
    try {
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (e) {
      return const Color(0xFF6C63FF);
    }
  }
}

