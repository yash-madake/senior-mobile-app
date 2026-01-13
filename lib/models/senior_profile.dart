class SeniorProfile {
  final String id;
  final String userId;
  final String name;
  final int age;
  final String address;
  final List<String> medicalConditions;
  final List<String> allergies;
  final List<String> medications;
  final String emergencyContact;
  final String emergencyContactPhone;
  final String? bloodType;
  final double? weight;
  final double? height;
  final Map<String, dynamic>? insuranceInfo;
  final DateTime createdAt;
  final DateTime updatedAt;

  SeniorProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.address,
    required this.medicalConditions,
    required this.allergies,
    required this.medications,
    required this.emergencyContact,
    required this.emergencyContactPhone,
    this.bloodType,
    this.weight,
    this.height,
    this.insuranceInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SeniorProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return SeniorProfile(
      id: id,
      userId: data['user_id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      age: data['age'] as int? ?? 0,
      address: data['address'] as String? ?? '',
      medicalConditions: List<String>.from(data['medical_conditions'] ?? []),
      allergies: List<String>.from(data['allergies'] ?? []),
      medications: List<String>.from(data['medications'] ?? []),
      emergencyContact: data['emergency_contact'] as String? ?? '',
      emergencyContactPhone: data['emergency_contact_phone'] as String? ?? '',
      bloodType: data['blood_type'] as String?,
      weight: (data['weight'] as num?)?.toDouble(),
      height: (data['height'] as num?)?.toDouble(),
      insuranceInfo: data['insurance_info'] as Map<String, dynamic>?,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'name': name,
      'age': age,
      'address': address,
      'medical_conditions': medicalConditions,
      'allergies': allergies,
      'medications': medications,
      'emergency_contact': emergencyContact,
      'emergency_contact_phone': emergencyContactPhone,
      'blood_type': bloodType,
      'weight': weight,
      'height': height,
      'insurance_info': insuranceInfo,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
