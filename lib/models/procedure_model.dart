class ProcedureList {
  List<ProcedureModel> list;

  ProcedureList({
    required this.list,
  });

  factory ProcedureList.fromJson(Map<String, dynamic> json) => ProcedureList(
        list: List<ProcedureModel>.from(
            json['getAllProcedure'].map((x) => ProcedureModel.fromJson(x))),
      );
}

class ProcedureModel {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final bool status;

  ProcedureModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory ProcedureModel.fromJson(Map<String, dynamic> json) {
    return ProcedureModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}
