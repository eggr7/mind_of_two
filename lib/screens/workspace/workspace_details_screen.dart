import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/workspace_model.dart';
import '../../models/user_model.dart';
import '../../providers/workspace_provider.dart';
import '../../providers/auth_provider.dart';

class WorkspaceDetailsScreen extends StatefulWidget {
  final WorkspaceModel workspace;

  const WorkspaceDetailsScreen({
    super.key,
    required this.workspace,
  });

  @override
  State<WorkspaceDetailsScreen> createState() => _WorkspaceDetailsScreenState();
}

class _WorkspaceDetailsScreenState extends State<WorkspaceDetailsScreen> {
  List<UserModel>? _members;
  bool _loadingMembers = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
    final members = await workspaceProvider.getWorkspaceMembers(widget.workspace.id);
    setState(() {
      _members = members;
      _loadingMembers = false;
    });
  }

  void _shareInviteCode() {
    final message = 'Join my workspace "${widget.workspace.name}" in Mind of Two!\n\n'
        'Invitation code: ${widget.workspace.inviteCode}\n\n'
        'Download the app and enter this code to collaborate.';
    
    Share.share(message);
  }

  void _copyInviteCode() {
    Clipboard.setData(ClipboardData(text: widget.workspace.inviteCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _leaveWorkspace() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Workspace'),
        content: Text(
          widget.workspace.isCreator(userId)
              ? 'You are the creator of this workspace. If you leave it, it will be deleted for all members.'
              : 'Are you sure you want to leave "${widget.workspace.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(widget.workspace.isCreator(userId) ? 'Delete' : 'Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    bool success;
    if (widget.workspace.isCreator(userId)) {
      success = await workspaceProvider.deleteWorkspace(
        workspaceId: widget.workspace.id,
        userId: userId,
      );
    } else {
      success = await workspaceProvider.leaveWorkspace(
        workspaceId: widget.workspace.id,
        userId: userId,
      );
    }

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.workspace.isCreator(userId)
                ? 'Workspace deleted'
                : 'You left the workspace',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else if (workspaceProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(workspaceProvider.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.currentUser?.uid;
    final isCreator = userId != null && widget.workspace.isCreator(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Workspace card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      widget.workspace.icon,
                      style: const TextStyle(fontSize: 64),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.workspace.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        widget.workspace.type == 'shared' ? 'Shared' : 'Personal',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(int.parse('0xFF${widget.workspace.color}')),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Invite code (only for shared workspaces)
            if (widget.workspace.type == 'shared') ...[
              const Text(
                'Invitation Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.workspace.inviteCode,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _copyInviteCode,
                              icon: const Icon(Icons.copy),
                              label: const Text('Copy'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _shareInviteCode,
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Members section
            const Text(
              'Members',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: _loadingMembers
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _members == null || _members!.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Text(
                            'Could not load members',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _members!.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final member = _members![index];
                            final isMemberCreator = widget.workspace.isCreator(member.uid);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: member.photoUrl != null
                                    ? NetworkImage(member.photoUrl!)
                                    : null,
                                child: member.photoUrl == null
                                    ? Text(member.displayName[0].toUpperCase())
                                    : null,
                              ),
                              title: Text(member.displayName),
                              subtitle: Text(member.email),
                              trailing: isMemberCreator
                                  ? Chip(
                                      label: const Text(
                                        'Creator',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                    )
                                  : null,
                            );
                          },
                        ),
            ),

            const SizedBox(height: 32),

            // Leave/Delete button
            OutlinedButton.icon(
              onPressed: _leaveWorkspace,
              icon: Icon(isCreator ? Icons.delete : Icons.exit_to_app),
              label: Text(isCreator ? 'Delete Workspace' : 'Leave Workspace'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

