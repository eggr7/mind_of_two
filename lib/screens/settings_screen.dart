import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final completedTasks = taskProvider.tasks.where((task) => task.completed).length;
    final totalTasks = taskProvider.tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Statistics Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Statistics",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatItem(
                      icon: Icons.task_outlined,
                      title: "Total Tasks",
                      value: "$totalTasks",
                    ),
                    const Divider(),
                    _buildStatItem(
                      icon: Icons.check_circle_outline,
                      title: "Completed Tasks",
                      value: "$completedTasks",
                    ),
                    const Divider(),
                    _buildStatItem(
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
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "App Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "Enable task reminders",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
                      icon: Icons.palette_outlined,
                      title: "Theme",
                      subtitle: "Change app appearance",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
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
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.person_outline,
                      title: "Profile",
                      subtitle: "Edit your information",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
                      icon: Icons.security_outlined,
                      title: "Privacy & Security",
                      subtitle: "Manage your data",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
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
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "App Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSettingItem(
                      icon: Icons.info_outline,
                      title: "Version",
                      subtitle: "1.0.0",
                    ),
                    const Divider(),
                    _buildSettingItem(
                      icon: Icons.email_outlined,
                      title: "Contact Support",
                      subtitle: "support@mindoftwo.com",
                      onTap: () {},
                    ),
                    const Divider(),
                    _buildSettingItem(
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
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF616161),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
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
        color: isDestructive ? Colors.red : const Color(0xFF6C63FF),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDestructive ? Colors.red : const Color(0xFF212121),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: isDestructive ? Colors.red.withOpacity(0.8) : const Color(0xFF757575),
        ),
      ),
      trailing: onTap != null
          ? Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red : const Color(0xFF9E9E9E),
            )
          : null,
    );
  }
}