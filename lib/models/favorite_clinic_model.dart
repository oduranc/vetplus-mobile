class FavoriteClinicList {
  List<FavoriteClinicModel> list;

  FavoriteClinicList({
    required this.list,
  });

  factory FavoriteClinicList.fromJson(Map<String, dynamic> json) {
    return FavoriteClinicList(
      list: List<FavoriteClinicModel>.from(json['getAllFavoriteClinic']
          .map((x) => FavoriteClinicModel.fromJson(x))),
    );
  }
}

class FavoriteClinicModel {
  final FavoriteClinicData clinicData;
  final String idUser;
  final String idClinic;
  final bool favorite;
  final int? points;

  FavoriteClinicModel({
    required this.clinicData,
    required this.idUser,
    required this.idClinic,
    required this.favorite,
    this.points,
  });

  factory FavoriteClinicModel.fromJson(Map<String, dynamic> json) {
    final clinicData = FavoriteClinicData.fromJson(json['Clinic']);

    return FavoriteClinicModel(
      clinicData: clinicData,
      idUser: json['id_user'],
      idClinic: json['id_clinic'],
      favorite: json['favorite'],
      points: json['points'],
    );
  }
}

class FavoriteClinicData {
  final String name;
  final String address;
  final String? image;

  FavoriteClinicData({required this.name, required this.address, this.image});

  factory FavoriteClinicData.fromJson(Map<String, dynamic> json) {
    return FavoriteClinicData(
      name: json['name'],
      address: json['address'],
      image: json['image'],
    );
  }
}
