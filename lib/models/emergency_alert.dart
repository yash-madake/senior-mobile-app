enum AlertType {
  fall,
  medical,
  sos,
  medicationMissed,
  abnormalVitals,
}

enum AlertStatus {
  active,
  acknowledged,
  resolved,
  falseAlarm,
}

class EmergencyAlert {
  final String id;
  final String seniorId;
  final AlertType type;
  final AlertStatus status;
  final String description;
  final DateTime triggeredAt;
  final String? location;
  final List<String> notifiedContacts;
  final DateTime? acknowledgedAt;
  final String? acknowledgedBy;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolution;
  final Map<String, dynamic>? metadata;

  EmergencyAlert({
    required this.id,
    required this.seniorId,
    required this.type,
    required this.status,
    required this.description,
    required this.triggeredAt,
    this.location,
    this.notifiedContacts = const [],
    this.acknowledgedAt,
    this.acknowledgedBy,
    this.resolvedAt,
    this.resolvedBy,
    this.resolution,
    this.metadata,
  });

  factory EmergencyAlert.fromFirestore(Map<String, dynamic> data, String id) {
    return EmergencyAlert(
      id: id,
      seniorId: data['senior_id'] as String? ?? '',
      type: AlertType.values.firstWhere(
        (e) => e.toString() == 'AlertType.${data['type']}',
        orElse: () => AlertType.sos,
      ),
      status: AlertStatus.values.firstWhere(
        (e) => e.toString() == 'AlertStatus.${data['status']}',
        orElse: () => AlertStatus.active,
      ),
      description: data['description'] as String? ?? '',
      triggeredAt: data['triggered_at'] != null
          ? DateTime.parse(data['triggered_at'] as String)
          : DateTime.now(),
      location: data['location'] as String?,
      notifiedContacts: List<String>.from(data['notified_contacts'] ?? []),
      acknowledgedAt: data['acknowledged_at'] != null
          ? DateTime.parse(data['acknowledged_at'] as String)
          : null,
      acknowledgedBy: data['acknowledged_by'] as String?,
      resolvedAt: data['resolved_at'] != null
          ? DateTime.parse(data['resolved_at'] as String)
          : null,
      resolvedBy: data['resolved_by'] as String?,
      resolution: data['resolution'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'senior_id': seniorId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'description': description,
      'triggered_at': triggeredAt.toIso8601String(),
      'location': location,
      'notified_contacts': notifiedContacts,
      'acknowledged_at': acknowledgedAt?.toIso8601String(),
      'acknowledged_by': acknowledgedBy,
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolved_by': resolvedBy,
      'resolution': resolution,
      'metadata': metadata,
    };
  }
}
