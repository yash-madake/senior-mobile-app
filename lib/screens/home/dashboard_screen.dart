import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildEmergencyButton(context),
              const SizedBox(height: 24),
              _buildQuickStats(context),
              const SizedBox(height: 24),
              _buildTodaysMedications(context),
              const SizedBox(height: 24),
              _buildUpcomingAppointments(context),
              const SizedBox(height: 24),
              _buildRecentVitals(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final name = authProvider.currentUser?.name ?? 'User';
    final hour = DateTime.now().hour;
    String greeting = 'Good Morning';
    if (hour >= 12 && hour < 18) {
      greeting = 'Good Afternoon';
    } else if (hour >= 18) {
      greeting = 'Good Evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8F5F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showEmergencyDialog(context);
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.sos,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMERGENCY SOS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap for immediate assistance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Heart Rate',
            '72',
            'bpm',
            Icons.favorite,
            const Color(0xFFFF6B35),
            const Color(0xFFFFE8E0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Blood Pressure',
            '120/80',
            'mmHg',
            Icons.monitor_heart_outlined,
            const Color(0xFF00A8A8),
            const Color(0xFFE0F7F7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon,
      Color iconColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysMedications(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final medications = userProvider.medications;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medication, color: Color(0xFFFF6B35)),
                SizedBox(width: 8),
                Text(
                  "Today's Medications",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (medications.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No medications scheduled',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...medications.take(3).map((med) => _buildMedicationCard(med)),
          ],
        );
      },
    );
  }

  Widget _buildMedicationCard(dynamic medication) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.medication,
            color: Color(0xFFFF6B35),
          ),
        ),
        title: Text(
          medication.medicationName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${medication.dosage} • ${medication.schedule.join(", ")}'),
        trailing: Checkbox(
          value: false,
          onChanged: (value) {},
          activeColor: const Color(0xFF00A8A8),
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final appointments = userProvider.appointments;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Color(0xFF00A8A8)),
                SizedBox(width: 8),
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (appointments.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No upcoming appointments',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...appointments
                  .take(2)
                  .map((appointment) => _buildAppointmentCard(appointment)),
          ],
        );
      },
    );
  }

  Widget _buildAppointmentCard(dynamic appointment) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF00A8A8).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.medical_services,
            color: Color(0xFF00A8A8),
          ),
        ),
        title: Text(
          appointment.type.toString().split('.').last.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(dateFormat.format(appointment.scheduledDateTime)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildRecentVitals(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final healthRecords = userProvider.healthRecords;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.trending_up, color: Color(0xFFFF6B35)),
                SizedBox(width: 8),
                Text(
                  'Recent Vitals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (healthRecords.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No health records available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              ...healthRecords.take(3).map((record) => _buildVitalCard(record)),
          ],
        );
      },
    );
  }

  Widget _buildVitalCard(dynamic record) {
    final timeFormat = DateFormat('hh:mm a');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFF00A8A8)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.monitor_heart,
            color: Colors.white,
          ),
        ),
        title: Text(
          record.vitalType.toString().split('.').last,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(timeFormat.format(record.recordedAt)),
        trailing: Text(
          record.secondaryValue != null
              ? '${record.value.toInt()}/${record.secondaryValue} ${record.unit}'
              : '${record.value.toInt()} ${record.unit}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Alert'),
          ],
        ),
        content: const Text(
          'This will send an emergency alert to all your emergency contacts and nearby caregivers. Do you want to proceed?',
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
                  content: Text('Emergency alert sent to all contacts!'),
                  backgroundColor: Colors.green,
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
