import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workspace_provider.dart';
import 'workspace_bottom_sheet.dart';

/// A compact widget that displays the current workspace and opens a selector when tapped
class WorkspaceSelectorWidget extends StatelessWidget {
  const WorkspaceSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context);
    final activeWorkspace = workspaceProvider.activeWorkspace;

    if (activeWorkspace == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const WorkspaceBottomSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getWorkspaceColor(activeWorkspace.color).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getWorkspaceColor(activeWorkspace.color).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeWorkspace.icon,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 70),
              child: Text(
                activeWorkspace.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getWorkspaceColor(activeWorkspace.color),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: _getWorkspaceColor(activeWorkspace.color),
            ),
          ],
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

