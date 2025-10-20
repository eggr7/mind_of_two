import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import 'manage_categories_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final completedTasks = taskProvider.tasks.where((task) => task.completed).length;
    final totalTasks = taskProvider.tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Statistics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem(
                      context: context,
                      icon: Icons.task_outlined,
                      title: "Total Tasks",
                      value: "$totalTasks",
                    ),
                    const Divider(),
                    _buildStatItem(
                      context: context,
                      icon: Icons.check_circle_outline,
                      title: "Completed Tasks",
                      value: "$completedTasks",
                    ),
                    const Divider(),
                    _buildStatItem(
                      context: context,
                      icon: Icons.analytics_outlined,
                      title: "Completion Rate",
                      value: totalTasks > 0 
                          ? "${(completedTasks / totalTasks * 100).toStringAsFixed(1)}%"
                          : "0%",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.category_outlined,
                      title: "Manage Categories",
                      subtitle: "Add, edit, or delete task categories",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ManageCategoriesScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "Enable task reminders",
                      onTap: () {},
                    ),
                    const Divider(),
                    SwitchListTile(
                      secondary: Icon(
                        themeProvider.isDarkMode 
                            ? Icons.dark_mode 
                            : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        "Toggle dark theme",
                        style: TextStyle(fontSize: 14),
                      ),
                      value: themeProvider.isDarkMode,
                      onChanged: (_) => themeProvider.toggleTheme(),
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.language_outlined,
                      title: "Language",
                      subtitle: "English",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Account Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.person_outline,
                      title: "Profile",
                      subtitle: "Edit your information",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.security_outlined,
                      title: "Privacy & Security",
                      subtitle: "Manage your data",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.exit_to_app_outlined,
                      title: "Sign Out",
                      subtitle: "Sign out of your account",
                      onTap: () {},
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.info_outline,
                      title: "Version",
                      subtitle: "1.0.0",
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.email_outlined,
                      title: "Contact Support",
                      subtitle: "support@mindoftwo.com",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
                      context: context,
                      icon: Icons.description_outlined,
                      title: "Privacy Policy",
                      subtitle: "View our privacy policy",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDestructive 
              ? Colors.red.withOpacity(0.8) 
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: isDestructive 
                  ? Colors.red 
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            )
          : null,
    );
  }
}