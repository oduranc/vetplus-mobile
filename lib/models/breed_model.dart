class BreedList {
  List<BreedModel> list;

  BreedList({
    required this.list,
  });

  factory BreedList.fromJson(Map<String, dynamic> json) => BreedList(
        list: List<BreedModel>.from(
            json['getAllBreed'].map((x) => BreedModel.fromJson(x))),
      );
}

class BreedModel {
  final int id;
  final int idSpecie;
  final String name;
  final String createdAt;
  final String updatedAt;
  final bool status;

  BreedModel({
    required this.id,
    required this.idSpecie,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      id: json['id'],
      idSpecie: json['id_specie'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}
