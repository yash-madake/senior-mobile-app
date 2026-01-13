import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Monitoring'),
        backgroundColor: const Color(0xFF00A8A8),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildVitalsTrend(context),
              const SizedBox(height: 24),
              _buildMedicationTracker(context),
              const SizedBox(height: 24),
              _buildHealthRecordsSection(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddVitalsDialog(context);
        },
        backgroundColor: const Color(0xFF00A8A8),
        icon: const Icon(Icons.add),
        label: const Text('Add Vitals'),
      ),
    );
  }

  Widget _buildVitalsTrend(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Heart Rate Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 70),
                        const FlSpot(1, 72),
                        const FlSpot(2, 68),
                        const FlSpot(3, 74),
                        const FlSpot(4, 72),
                        const FlSpot(5, 75),
                      ],
                      isCurved: true,
                      color: const Color(0xFFFF6B35),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFFFF6B35).withValues(alpha: 0.1),
                      ),
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

  Widget _buildMedicationTracker(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final medications = userProvider.medications;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medication, color: Color(0xFFFF6B35)),
                    SizedBox(width: 8),
                    Text(
                      'Medication Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (medications.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No medications scheduled'),
                    ),
                  )
                else
                  ...medications.map((med) => ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFE8E0),
                          child: Icon(Icons.medication, color: Color(0xFFFF6B35)),
                        ),
                        title: Text(
                          med.medicationName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('${med.dosage} • ${med.schedule.join(", ")}'),
                        trailing: Switch(
                          value: med.isActive,
                          onChanged: (value) {},
                          activeTrackColor: const Color(0xFF00A8A8),
                        ),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthRecordsSection(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final records = userProvider.healthRecords;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.monitor_heart, color: Color(0xFF00A8A8)),
                    SizedBox(width: 8),
                    Text(
                      'Recent Vitals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (records.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No health records available'),
                    ),
                  )
                else
                  ...records.map((record) {
                    final timeFormat = DateFormat('MMM dd, hh:mm a');
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFFE0F7F7),
                        child: Icon(
                          _getVitalIcon(record.vitalType.toString()),
                          color: const Color(0xFF00A8A8),
                        ),
                      ),
                      title: Text(
                        record.vitalType.toString().split('.').last,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(timeFormat.format(record.recordedAt)),
                      trailing: Text(
                        record.secondaryValue != null
                            ? '${record.value.toInt()}/${record.secondaryValue}'
                            : '${record.value.toInt()} ${record.unit}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getVitalIcon(String vitalType) {
    if (vitalType.contains('bloodPressure')) return Icons.monitor_heart;
    if (vitalType.contains('heartRate')) return Icons.favorite;
    if (vitalType.contains('bloodSugar')) return Icons.bloodtype;
    if (vitalType.contains('temperature')) return Icons.thermostat;
    if (vitalType.contains('oxygenSaturation')) return Icons.air;
    return Icons.health_and_safety;
  }

  void _showAddVitalsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Vital Signs'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Blood Pressure (Systolic)',
                hintText: '120',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Blood Pressure (Diastolic)',
                hintText: '80',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: 'Heart Rate (bpm)',
                hintText: '72',
              ),
              keyboardType: TextInputType.number,
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
                  content: Text('Vitals recorded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A8A8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
