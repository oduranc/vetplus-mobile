class PetList {
  List<PetModel> list;

  PetList({
    required this.list,
  });

  factory PetList.fromJson(Map<String, dynamic> json) => PetList(
        list: List<PetModel>.from(
            json['getMyPets'].map((x) => PetModel.fromJson(x))),
      );
}

enum AgeUnit { days, months, years }

class PetModel {
  final String id;
  final String idOwner;
  final int idSpecie;
  final int idBreed;
  final String name;
  final String? image;
  final String gender;
  final bool castrated;
  final String? dob;
  final String? observations;
  final String createdAt;
  final String updatedAt;
  final bool status;
  final String age;

  PetModel({
    required this.id,
    required this.idOwner,
    required this.idSpecie,
    required this.idBreed,
    required this.name,
    this.image,
    required this.gender,
    required this.castrated,
    this.dob,
    this.observations,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.age,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    final dobString = json['dob'] as String?;
    final dob = dobString != null ? DateTime.parse(dobString) : null;
    final now = DateTime.now();

    String age = '';

    if (dob != null) {
      final difference = now.difference(dob);

      if (difference.inDays < 30) {
        age = '${difference.inDays} ${AgeUnit.days}';
      } else if (difference.inDays < 365) {
        age = '${difference.inDays ~/ 30} ${AgeUnit.months}';
      } else {
        age = '${difference.inDays ~/ 365} ${AgeUnit.years}';
      }
    }

    return PetModel(
      id: json['id'],
      idOwner: json['id_owner'],
      idSpecie: json['id_specie'],
      idBreed: json['id_breed'],
      name: json['name'],
      image: json['image'],
      gender: json['gender'],
      castrated: json['castrated'],
      dob: json['dob'],
      observations: json['observations'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      age: age,
    );
  }
}
