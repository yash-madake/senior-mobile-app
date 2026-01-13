import 'package:flutter/foundation.dart';
import '../models/senior_profile.dart';
import '../models/caregiver_profile.dart';
import '../models/health_record.dart';
import '../models/appointment.dart';
import '../models/emergency_alert.dart';

class UserProvider with ChangeNotifier {
  SeniorProfile? _seniorProfile;
  CaregiverProfile? _caregiverProfile;
  List<HealthRecord> _healthRecords = [];
  List<MedicationSchedule> _medications = [];
  List<Appointment> _appointments = [];
  List<EmergencyAlert> _emergencyAlerts = [];
  bool _isLoading = false;

  SeniorProfile? get seniorProfile => _seniorProfile;
  CaregiverProfile? get caregiverProfile => _caregiverProfile;
  List<HealthRecord> get healthRecords => _healthRecords;
  List<MedicationSchedule> get medications => _medications;
  List<Appointment> get appointments => _appointments;
  List<EmergencyAlert> get emergencyAlerts => _emergencyAlerts;
  bool get isLoading => _isLoading;

  void setSeniorProfile(SeniorProfile profile) {
    _seniorProfile = profile;
    notifyListeners();
  }

  void setCaregiverProfile(CaregiverProfile profile) {
    _caregiverProfile = profile;
    notifyListeners();
  }

  void setHealthRecords(List<HealthRecord> records) {
    _healthRecords = records;
    notifyListeners();
  }

  void addHealthRecord(HealthRecord record) {
    _healthRecords.add(record);
    notifyListeners();
  }

  void setMedications(List<MedicationSchedule> meds) {
    _medications = meds;
    notifyListeners();
  }

  void setAppointments(List<Appointment> apps) {
    _appointments = apps;
    notifyListeners();
  }

  void setEmergencyAlerts(List<EmergencyAlert> alerts) {
    _emergencyAlerts = alerts;
    notifyListeners();
  }

  void addEmergencyAlert(EmergencyAlert alert) {
    _emergencyAlerts.insert(0, alert);
    notifyListeners();
  }

  Future<void> loadMockData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // Mock senior profile
    _seniorProfile = SeniorProfile(
      id: 'senior_001',
      userId: 'user_001',
      name: 'John Smith',
      age: 75,
      address: '123 Oak Street, Springfield',
      medicalConditions: ['Hypertension', 'Type 2 Diabetes'],
      allergies: ['Penicillin'],
      medications: ['Metformin', 'Lisinopril'],
      emergencyContact: 'Jane Smith',
      emergencyContactPhone: '+1 555-0123',
      bloodType: 'O+',
      weight: 180.0,
      height: 5.8,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
    );

    // Mock health records
    _healthRecords = [
      HealthRecord(
        id: 'hr_001',
        seniorId: 'senior_001',
        vitalType: VitalType.bloodPressure,
        value: 120,
        secondaryValue: '80',
        unit: 'mmHg',
        recordedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      HealthRecord(
        id: 'hr_002',
        seniorId: 'senior_001',
        vitalType: VitalType.heartRate,
        value: 72,
        unit: 'bpm',
        recordedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      HealthRecord(
        id: 'hr_003',
        seniorId: 'senior_001',
        vitalType: VitalType.bloodSugar,
        value: 110,
        unit: 'mg/dL',
        recordedAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];

    // Mock medications
    _medications = [
      MedicationSchedule(
        id: 'med_001',
        seniorId: 'senior_001',
        medicationName: 'Metformin',
        dosage: '500mg',
        schedule: ['08:00', '20:00'],
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        notes: 'Take with food',
      ),
      MedicationSchedule(
        id: 'med_002',
        seniorId: 'senior_001',
        medicationName: 'Lisinopril',
        dosage: '10mg',
        schedule: ['08:00'],
        startDate: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ];

    // Mock appointments
    _appointments = [
      Appointment(
        id: 'app_001',
        seniorId: 'senior_001',
        caregiverId: 'care_001',
        type: AppointmentType.checkup,
        status: AppointmentStatus.scheduled,
        scheduledDateTime: DateTime.now().add(const Duration(days: 2)),
        durationMinutes: 60,
        notes: 'Regular monthly checkup',
        createdAt: DateTime.now(),
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
