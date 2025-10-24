import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workspace_model.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';

class ImportTasksDialog extends StatefulWidget {
  final WorkspaceModel workspace;
  final int taskCount;

  const ImportTasksDialog({
    super.key,
    required this.workspace,
    required this.taskCount,
  });

  @override
  State<ImportTasksDialog> createState() => _ImportTasksDialogState();
}

class _ImportTasksDialogState extends State<ImportTasksDialog> {
  bool _isImporting = false;
  double _progress = 0.0;

  Future<void> _importTasks() async {
    setState(() {
      _isImporting = true;
      _progress = 0.0;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) return;

    try {
      final firestoreService = FirestoreService();
      
      await firestoreService.syncLocalToFirestore(
        userId: userId,
        workspaceId: widget.workspace.id,
      );

      setState(() {
        _progress = 1.0;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.taskCount} tasks imported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isImporting = false;
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error importing: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.cloud_upload,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          const Text('Import Tasks'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have ${widget.taskCount} task${widget.taskCount != 1 ? 's' : ''} local${widget.taskCount != 1 ? 's' : ''}.',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'Do you want to import them to "${widget.workspace.name}"?',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'The tasks will be synchronized with all the members of the workspace',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isImporting) ...[
            const SizedBox(height: 20),
            LinearProgressIndicator(value: _progress),
            const SizedBox(height: 8),
            Text(
              _progress < 1.0 ? 'Importing...' : 'Completed!',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
      actions: _isImporting
          ? []
          : [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Start Clean'),
              ),
              ElevatedButton(
                onPressed: _importTasks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Import'),
              ),
            ],
    );
  }
}

