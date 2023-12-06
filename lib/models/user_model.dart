class UserModel {
  final String id;
  final String names;
  final String? surnames;
  final String email;
  final String provider;
  final String? document;
  final String? address;
  final String? telephoneNumber;
  final String? image;
  final String role;
  final String createdAt;
  final String updatedAt;
  final bool status;
  final UserFmcModel? userFmc;
  final VetSpecialty? vetSpecialty;

  UserModel({
    required this.id,
    required this.names,
    this.surnames,
    required this.email,
    required this.provider,
    this.document,
    this.address,
    this.telephoneNumber,
    this.image,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.userFmc,
    this.vetSpecialty,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      names: json['names'],
      surnames: json['surnames'],
      email: json['email'],
      provider: json['provider'],
      document: json['document'],
      address: json['address'],
      telephoneNumber: json['telephone_number'],
      image: json['image'],
      role: json['role'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      userFmc: json['User_Fmc'] != null
          ? UserFmcModel.fromJson(json['User_Fmc'])
          : null,
      vetSpecialty: json['VeterinariaSpecialties'] != null
          ? VetSpecialty.fromJson(json['VeterinariaSpecialties'])
          : null,
    );
  }
}

class VetSpecialty {
  String? specialty;

  VetSpecialty({this.specialty});

  factory VetSpecialty.fromJson(Map<String, dynamic> json) {
    return VetSpecialty(
      specialty: json['specialties'],
    );
  }
}

class UserFmcModel {
  String? idUser;
  String? tokenFmc;

  UserFmcModel({
    this.idUser,
    this.tokenFmc,
  });

  factory UserFmcModel.fromJson(Map<String, dynamic> json) {
    return UserFmcModel(
      idUser: json['id_user'],
      tokenFmc: json['token_fmc'],
    );
  }
}
