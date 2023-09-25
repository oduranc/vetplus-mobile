class ClinicList {
  List<ClinicModel> list;

  ClinicList({
    required this.list,
  });

  factory ClinicList.fromJson(Map<String, dynamic> json) => ClinicList(
        list: List<ClinicModel>.from(
            json['getAllClinic'].map((x) => ClinicModel.fromJson(x))),
      );
}

class ClinicModel {
  final String id;
  final String idOwner;
  final String name;
  final String telephoneNumber;
  final String? googleMapsUrl;
  final String? email;
  final String? image;
  final String address;
  final String createdAt;
  final String updatedAt;
  final bool status;
  final ClinicSummaryScoreModel clinicSummaryScore;
  final String clinicRating;
  final List<Object?>? services;
  final Schedule? schedule;

  ClinicModel({
    required this.id,
    required this.idOwner,
    required this.name,
    required this.telephoneNumber,
    this.googleMapsUrl,
    this.email,
    this.image,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.clinicSummaryScore,
    required this.clinicRating,
    this.services,
    this.schedule,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    final clinicSummaryScore =
        ClinicSummaryScoreModel.fromJson(json['ClinicSummaryScore']);
    final clinicRating = double.parse(
            (clinicSummaryScore.totalPoints / clinicSummaryScore.totalUsers)
                .toString())
        .toStringAsFixed(1);

    Schedule? schedule;
    if (json['schedule'] != null) {
      schedule = Schedule.fromJson(json['schedule']);
    }

    return ClinicModel(
      id: json['id'],
      idOwner: json['id_owner'],
      name: json['name'],
      telephoneNumber: json['telephone_number'],
      googleMapsUrl: json['google_maps_url'],
      email: json['email'],
      image: json['image'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      clinicSummaryScore: clinicSummaryScore,
      clinicRating: clinicRating,
      services: json['services'],
      schedule: schedule,
    );
  }
}

class ClinicSummaryScoreModel {
  final int totalPoints;
  final int totalUsers;

  ClinicSummaryScoreModel({
    required this.totalPoints,
    required this.totalUsers,
  });

  factory ClinicSummaryScoreModel.fromJson(Map<String, dynamic> json) {
    return ClinicSummaryScoreModel(
      totalPoints: json['total_points'],
      totalUsers: json['total_users'],
    );
  }
}

class Schedule {
  final List<Object?> nonWorkingDays;

  Schedule({
    required this.nonWorkingDays,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      nonWorkingDays: json['nonWorkingDays'],
    );
  }
}