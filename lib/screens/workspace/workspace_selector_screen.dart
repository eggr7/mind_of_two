import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/workspace_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/workspace_model.dart';
import 'create_workspace_screen.dart';
import 'join_workspace_screen.dart';
import 'workspace_details_screen.dart';

class WorkspaceSelectorScreen extends StatelessWidget {
  const WorkspaceSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workspaces'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: workspaceProvider.workspaces.isEmpty
          ? _buildEmptyState(context)
          : _buildWorkspaceList(context, workspaceProvider),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'join',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const JoinWorkspaceScreen(),
                ),
              );
            },
            child: const Icon(Icons.group_add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'create',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const CreateWorkspaceScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Workspace'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.workspaces_outline,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'No you have workspaces',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Create a new workspace or join an existing one with an invitation code',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkspaceList(BuildContext context, WorkspaceProvider workspaceProvider) {
    final personalWorkspaces = workspaceProvider.workspaces
        .where((w) => w.type == 'personal')
        .toList();
    final sharedWorkspaces = workspaceProvider.workspaces
        .where((w) => w.type == 'shared')
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: 'Shared (${sharedWorkspaces.length})',
                icon: const Icon(Icons.people),
              ),
              Tab(
                text: 'Personal (${personalWorkspaces.length})',
                icon: const Icon(Icons.person),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildWorkspaceGrid(context, sharedWorkspaces, workspaceProvider),
                _buildWorkspaceGrid(context, personalWorkspaces, workspaceProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceGrid(
    BuildContext context,
    List<WorkspaceModel> workspaces,
    WorkspaceProvider workspaceProvider,
  ) {
    if (workspaces.isEmpty) {
      return Center(
        child: Text(
          'No there are workspaces in this category',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: workspaces.length,
      itemBuilder: (context, index) {
        final workspace = workspaces[index];
        final isActive = workspace.id == workspaceProvider.activeWorkspace?.id;

        return Card(
          elevation: isActive ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () async {
              await workspaceProvider.setActiveWorkspace(workspace);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Workspace "${workspace.name}" activated'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            onLongPress: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => WorkspaceDetailsScreen(workspace: workspace),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    workspace.icon,
                    style: const TextStyle(fontSize: 48),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    workspace.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        workspace.type == 'shared' ? Icons.people : Icons.person,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${workspace.members.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  if (isActive) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACTIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

