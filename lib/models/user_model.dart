class UserModel {
  final String id;
  final String names;
  final String surnames;
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

  UserModel({
    required this.id,
    required this.names,
    required this.surnames,
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
    );
  }
}
