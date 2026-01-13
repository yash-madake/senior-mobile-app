enum VitalType {
  bloodPressure,
  heartRate,
  bloodSugar,
  temperature,
  oxygenSaturation,
  weight,
}

class HealthRecord {
  final String id;
  final String seniorId;
  final VitalType vitalType;
  final double value;
  final String? secondaryValue; // For blood pressure (e.g., "120/80")
  final String unit;
  final DateTime recordedAt;
  final String? notes;
  final String? recordedBy;

  HealthRecord({
    required this.id,
    required this.seniorId,
    required this.vitalType,
    required this.value,
    this.secondaryValue,
    required this.unit,
    required this.recordedAt,
    this.notes,
    this.recordedBy,
  });

  factory HealthRecord.fromFirestore(Map<String, dynamic> data, String id) {
    return HealthRecord(
      id: id,
      seniorId: data['senior_id'] as String? ?? '',
      vitalType: VitalType.values.firstWhere(
        (e) => e.toString() == 'VitalType.${data['vital_type']}',
        orElse: () => VitalType.heartRate,
      ),
      value: (data['value'] as num?)?.toDouble() ?? 0.0,
      secondaryValue: data['secondary_value'] as String?,
      unit: data['unit'] as String? ?? '',
      recordedAt: data['recorded_at'] != null
          ? DateTime.parse(data['recorded_at'] as String)
          : DateTime.now(),
      notes: data['notes'] as String?,
      recordedBy: data['recorded_by'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senior_id': seniorId,
      'vital_type': vitalType.toString().split('.').last,
      'value': value,
      'secondary_value': secondaryValue,
      'unit': unit,
      'recorded_at': recordedAt.toIso8601String(),
      'notes': notes,
      'recorded_by': recordedBy,
    };
  }
}

class MedicationSchedule {
  final String id;
  final String seniorId;
  final String medicationName;
  final String dosage;
  final List<String> schedule; // Times of day (e.g., ["08:00", "20:00"])
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool isActive;
  final List<DateTime> takenDates;

  MedicationSchedule({
    required this.id,
    required this.seniorId,
    required this.medicationName,
    required this.dosage,
    required this.schedule,
    required this.startDate,
    this.endDate,
    this.notes,
    this.isActive = true,
    this.takenDates = const [],
  });

  factory MedicationSchedule.fromFirestore(Map<String, dynamic> data, String id) {
    return MedicationSchedule(
      id: id,
      seniorId: data['senior_id'] as String? ?? '',
      medicationName: data['medication_name'] as String? ?? '',
      dosage: data['dosage'] as String? ?? '',
      schedule: List<String>.from(data['schedule'] ?? []),
      startDate: data['start_date'] != null
          ? DateTime.parse(data['start_date'] as String)
          : DateTime.now(),
      endDate: data['end_date'] != null
          ? DateTime.parse(data['end_date'] as String)
          : null,
      notes: data['notes'] as String?,
      isActive: data['is_active'] as bool? ?? true,
      takenDates: (data['taken_dates'] as List?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senior_id': seniorId,
      'medication_name': medicationName,
      'dosage': dosage,
      'schedule': schedule,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'notes': notes,
      'is_active': isActive,
      'taken_dates': takenDates.map((e) => e.toIso8601String()).toList(),
    };
  }
}
