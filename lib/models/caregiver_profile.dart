class CaregiverProfile {
  final String id;
  final String userId;
  final String name;
  final String bio;
  final List<String> specializations;
  final List<String> certifications;
  final int yearsOfExperience;
  final double hourlyRate;
  final double trustScore;
  final int totalBookings;
  final int completedBookings;
  final double averageRating;
  final int totalReviews;
  final List<String> languages;
  final String? profileImageUrl;
  final bool isVerified;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? availability;

  CaregiverProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.bio,
    required this.specializations,
    required this.certifications,
    required this.yearsOfExperience,
    required this.hourlyRate,
    this.trustScore = 0.0,
    this.totalBookings = 0,
    this.completedBookings = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    required this.languages,
    this.profileImageUrl,
    this.isVerified = false,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
    this.availability,
  });

  factory CaregiverProfile.fromFirestore(Map<String, dynamic> data, String id) {
    return CaregiverProfile(
      id: id,
      userId: data['user_id'] as String? ?? '',
      name: data['name'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      specializations: List<String>.from(data['specializations'] ?? []),
      certifications: List<String>.from(data['certifications'] ?? []),
      yearsOfExperience: data['years_of_experience'] as int? ?? 0,
      hourlyRate: (data['hourly_rate'] as num?)?.toDouble() ?? 0.0,
      trustScore: (data['trust_score'] as num?)?.toDouble() ?? 0.0,
      totalBookings: data['total_bookings'] as int? ?? 0,
      completedBookings: data['completed_bookings'] as int? ?? 0,
      averageRating: (data['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: data['total_reviews'] as int? ?? 0,
      languages: List<String>.from(data['languages'] ?? []),
      profileImageUrl: data['profile_image_url'] as String?,
      isVerified: data['is_verified'] as bool? ?? false,
      isAvailable: data['is_available'] as bool? ?? true,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'] as String)
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'] as String)
          : DateTime.now(),
      availability: data['availability'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'name': name,
      'bio': bio,
      'specializations': specializations,
      'certifications': certifications,
      'years_of_experience': yearsOfExperience,
      'hourly_rate': hourlyRate,
      'trust_score': trustScore,
      'total_bookings': totalBookings,
      'completed_bookings': completedBookings,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'languages': languages,
      'profile_image_url': profileImageUrl,
      'is_verified': isVerified,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'availability': availability,
    };
  }
}
