import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: const Color(0xFF00A8A8),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildProfileHeader(context),
              const SizedBox(height: 24),
              _buildHealthSummary(context),
              const SizedBox(height: 16),
              _buildSettingsList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = authProvider.currentUser;
    final senior = userProvider.seniorProfile;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFFFFE8E0),
              child: Text(
                user?.name[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? 'email@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (senior != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${senior.age} years old',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
              color: const Color(0xFF00A8A8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSummary(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final senior = userProvider.seniorProfile;

    if (senior == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHealthItem(
              'Blood Type',
              senior.bloodType ?? 'Not specified',
              Icons.bloodtype,
            ),
            _buildHealthItem(
              'Medical Conditions',
              senior.medicalConditions.join(', '),
              Icons.medical_information,
            ),
            _buildHealthItem(
              'Allergies',
              senior.allergies.isNotEmpty
                  ? senior.allergies.join(', ')
                  : 'None',
              Icons.warning_amber,
            ),
            _buildHealthItem(
              'Emergency Contact',
              '${senior.emergencyContact}\n${senior.emergencyContactPhone}',
              Icons.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF00A8A8), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsCard(
          'Account Settings',
          [
            _buildSettingsItem(
              'Personal Information',
              Icons.person_outline,
              () {},
            ),
            _buildSettingsItem(
              'Security & Privacy',
              Icons.security,
              () {},
            ),
            _buildSettingsItem(
              'Notifications',
              Icons.notifications_outlined,
              () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          'Care Settings',
          [
            _buildSettingsItem(
              'Medical Records',
              Icons.folder_outlined,
              () {},
            ),
            _buildSettingsItem(
              'Emergency Contacts',
              Icons.contacts_outlined,
              () {},
            ),
            _buildSettingsItem(
              'Medication Reminders',
              Icons.alarm,
              () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSettingsCard(
          'Support',
          [
            _buildSettingsItem(
              'Help Center',
              Icons.help_outline,
              () {},
            ),
            _buildSettingsItem(
              'About',
              Icons.info_outline,
              () {},
            ),
            _buildSettingsItem(
              'Logout',
              Icons.logout,
              () => _handleLogout(context),
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsCard(String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : const Color(0xFF00A8A8),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
