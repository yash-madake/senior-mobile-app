import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencyContacts = _getMockEmergencyContacts();
    final alertHistory = _getMockAlertHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Response'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSOSButton(context),
              const SizedBox(height: 24),
              _buildEmergencyContacts(emergencyContacts),
              const SizedBox(height: 24),
              _buildAlertHistory(alertHistory),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSOSButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.red, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showEmergencyConfirmation(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sos,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'EMERGENCY SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to send immediate alert',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContacts(List<Map<String, String>> contacts) {
    return Builder(
      builder: (context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.contacts, color: Color(0xFFFF6B35)),
                  SizedBox(width: 8),
                  Text(
                    'Emergency Contacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...contacts.map((contact) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFFFE8E0),
                      child: Text(
                        contact['name']![0],
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      contact['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(contact['relationship']!),
                    trailing: IconButton(
                      icon: const Icon(Icons.phone, color: Color(0xFF00A8A8)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Calling ${contact['name']}...'),
                          ),
                        );
                      },
                    ),
                  )),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertHistory(List<Map<String, dynamic>> history) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.history, color: Color(0xFF00A8A8)),
                SizedBox(width: 8),
                Text(
                  'Alert History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No emergency alerts'),
                ),
              )
            else
              ...history.map((alert) {
                final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getAlertColor(alert['type']!)
                        .withValues(alpha: 0.2),
                    child: Icon(
                      _getAlertIcon(alert['type']!),
                      color: _getAlertColor(alert['type']!),
                    ),
                  ),
                  title: Text(
                    alert['type']!,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(dateFormat.format(alert['timestamp'])),
                  trailing: Chip(
                    label: Text(
                      alert['status']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: _getStatusColor(alert['status']!),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getMockEmergencyContacts() {
    return [
      {'name': 'Jane Smith', 'relationship': 'Daughter', 'phone': '+1 555-0123'},
      {'name': 'Dr. Robert Wilson', 'relationship': 'Primary Physician', 'phone': '+1 555-0456'},
      {'name': 'Sarah Johnson', 'relationship': 'Caregiver', 'phone': '+1 555-0789'},
    ];
  }

  List<Map<String, dynamic>> _getMockAlertHistory() {
    return [
      {
        'type': 'Fall Detected',
        'status': 'Resolved',
        'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'type': 'Medication Missed',
        'status': 'Resolved',
        'timestamp': DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        'type': 'Abnormal Vitals',
        'status': 'Resolved',
        'timestamp': DateTime.now().subtract(const Duration(days: 20)),
      },
    ];
  }

  IconData _getAlertIcon(String type) {
    if (type.contains('Fall')) return Icons.warning;
    if (type.contains('Medication')) return Icons.medication;
    if (type.contains('Vitals')) return Icons.monitor_heart;
    return Icons.emergency;
  }

  Color _getAlertColor(String type) {
    if (type.contains('Fall')) return Colors.red;
    if (type.contains('Medication')) return Colors.orange;
    if (type.contains('Vitals')) return Colors.amber;
    return Colors.red;
  }

  Color _getStatusColor(String status) {
    if (status == 'Resolved') return Colors.green.withValues(alpha: 0.2);
    if (status == 'Active') return Colors.red.withValues(alpha: 0.2);
    return Colors.grey.withValues(alpha: 0.2);
  }

  void _showEmergencyConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Text('Emergency Alert'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• Send SMS to all emergency contacts'),
            Text('• Alert nearby caregivers'),
            Text('• Share your current location'),
            Text('• Trigger fall detection sensors'),
            SizedBox(height: 16),
            Text(
              'Do you want to proceed?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Emergency alert sent to all contacts!'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Send Alert'),
          ),
        ],
      ),
    );
  }
}
