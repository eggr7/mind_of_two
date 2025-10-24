import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/workspace_provider.dart';
import '../../providers/auth_provider.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  const CreateWorkspaceScreen({super.key});

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _selectedType = 'shared';
  String _selectedIcon = '👥';
  String _selectedColor = '6C63FF';

  final List<String> _icons = [
    '👥', '💼', '🏠', '❤️', '👨‍👩‍👧‍👦', '🎯', '📋', '✅', 
    '🌟', '💡', '🚀', '🏆', '📚', '🎨', '🎵', '⚽'
  ];

  final Map<String, Color> _colors = {
    '6C63FF': const Color(0xFF6C63FF), // Purple
    'F50057': const Color(0xFFF50057), // Pink
    'FF9800': const Color(0xFFFF9800), // Orange
    '4CAF50': const Color(0xFF4CAF50), // Green
    '2196F3': const Color(0xFF2196F3), // Blue
    '9C27B0': const Color(0xFF9C27B0), // Deep Purple
    'FF5722': const Color(0xFFFF5722), // Deep Orange
    '00BCD4': const Color(0xFF00BCD4), // Cyan
  };

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createWorkspace() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final workspaceProvider = Provider.of<WorkspaceProvider>(context, listen: false);

    final userId = authProvider.currentUser?.uid;
    if (userId == null) return;

    final workspace = await workspaceProvider.createWorkspace(
      name: _nameController.text.trim(),
      type: _selectedType,
      userId: userId,
      icon: _selectedIcon,
      color: _selectedColor,
    );

    if (!mounted) return;

    if (workspace != null) {
      // Show invite code if it's a shared workspace
      if (_selectedType == 'shared') {
        await _showInviteCodeDialog(workspace.inviteCode);
      }
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Workspace "${workspace.name}" created successfully'),
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

  Future<void> _showInviteCodeDialog(String inviteCode) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Workspace Created!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your partner or team:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    inviteCode,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Code copied'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    tooltip: 'Copy code',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workspace'),
      ),
      body: Consumer<WorkspaceProvider>(
        builder: (context, workspaceProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Preview card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text(
                            _selectedIcon,
                            style: const TextStyle(fontSize: 64),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _nameController.text.isEmpty
                                ? 'Workspace name'
                                : _nameController.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(
                              _selectedType == 'shared' ? 'Shared' : 'Personal',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            backgroundColor: _colors[_selectedColor],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Workspace name',
                      prefixIcon: Icon(Icons.edit_outlined),
                      hintText: 'Example: Home, Work, Project...',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter a name';
                      }
                      if (value.trim().length < 2) {
                        return 'The name is too short';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Type selector
                  const Text(
                    'Workspace type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeCard(
                          type: 'shared',
                          icon: Icons.people,
                          title: 'Shared',
                          subtitle: 'To work in team',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTypeCard(
                          type: 'personal',
                          icon: Icons.person,
                          title: 'Personal',
                          subtitle: 'Only for you',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Icon selector
                  const Text(
                    'Choose an icon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _icons.map((icon) {
                      final isSelected = icon == _selectedIcon;
                      return InkWell(
                        onTap: () => setState(() => _selectedIcon = icon),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _colors[_selectedColor]?.withOpacity(0.2)
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? _colors[_selectedColor]!
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              icon,
                              style: const TextStyle(fontSize: 32),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Color selector
                  const Text(
                    'Choose a color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _colors.entries.map((entry) {
                      final isSelected = entry.key == _selectedColor;
                      return InkWell(
                        onTap: () => setState(() => _selectedColor = entry.key),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: entry.value,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: entry.value.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Create button
                  ElevatedButton(
                    onPressed: workspaceProvider.isLoading ? null : _createWorkspace,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colors[_selectedColor],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: workspaceProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Create Workspace',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _colors[_selectedColor]?.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _colors[_selectedColor]! : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? _colors[_selectedColor] : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? _colors[_selectedColor] : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

