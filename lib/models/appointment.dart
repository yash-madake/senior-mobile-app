enum AppointmentType {
  checkup,
  consultation,
  homeVisit,
  telemedicine,
  emergency,
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
}

class Appointment {
  final String id;
  final String seniorId;
  final String caregiverId;
  final AppointmentType type;
  final AppointmentStatus status;
  final DateTime scheduledDateTime;
  final int durationMinutes;
  final String? notes;
  final String? location;
  final String? videoCallLink;
  final DateTime createdAt;
  final DateTime? completedAt;
  final Map<String, dynamic>? feedback;

  Appointment({
    required this.id,
    required this.seniorId,
    required this.caregiverId,
    required this.type,
    required this.status,
    required this.scheduledDateTime,
    this.durationMinutes = 60,
    this.notes,
    this.location,
    this.videoCallLink,
    required this.createdAt,
    this.completedAt,
    this.feedback,
  });

  factory Appointment.fromFirestore(Map<String, dynamic> data, String id) {
    return Appointment(
      id: id,
      seniorId: data['senior_id'] as String? ?? '',
      caregiverId: data['caregiver_id'] as String? ?? '',
      type: AppointmentType.values.firstWhere(
        (e) => e.toString() == 'AppointmentType.${data['type']}',
        orElse: () => AppointmentType.checkup,
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.toString() == 'AppointmentStatus.${data['status']}',
        orElse: () => AppointmentStatus.scheduled,
      ),
      scheduledDateTime: data['scheduled_date_time'] != null
          ? DateTime.parse(data['scheduled_date_time'] as String)
          : DateTime.now(),
      durationMinutes: data['duration_minutes'] as int? ?? 60,
      notes: data['notes'] as String?,
      location: data['location'] as String?,
      videoCallLink: data['video_call_link'] as String?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
      feedback: data['feedback'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senior_id': seniorId,
      'caregiver_id': caregiverId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'scheduled_date_time': scheduledDateTime.toIso8601String(),
      'duration_minutes': durationMinutes,
      'notes': notes,
      'location': location,
      'video_call_link': videoCallLink,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'feedback': feedback,
    };
  }
}
