class CommentList {
  List<CommentModel> list;

  CommentList({
    required this.list,
  });

  factory CommentList.fromJson(Map<String, dynamic> json) {
    return CommentList(
      list: List<CommentModel>.from(
          json['getAllCommentByIdClinic'].map((x) => CommentModel.fromJson(x))),
    );
  }
}

class CommentModel {
  final String id;
  final String idClinic;
  final String idOwner;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final bool status;
  final Owner owner;

  CommentModel({
    required this.id,
    required this.idClinic,
    required this.idOwner,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.owner,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final owner = Owner.fromJson(json['Owner']);

    return CommentModel(
      id: json['id'],
      idClinic: json['id_clinic'],
      idOwner: json['id_owner'],
      comment: json['comment'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      owner: owner,
    );
  }
}

class Owner {
  final String names;
  final String? surnames;
  final String? image;
  final List<UserClinicPoint>? clinicUsers;

  Owner({
    required this.names,
    required this.surnames,
    this.image,
    this.clinicUsers,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    final clinicUsers = List<UserClinicPoint>.from(
        json['ClinicUsers'].map((x) => UserClinicPoint.fromJson(x)));

    return Owner(
      names: json['names'],
      surnames: json['surnames'],
      image: json['image'],
      clinicUsers: clinicUsers,
    );
  }
}

class UserClinicPoint {
  final int? points;

  UserClinicPoint({this.points});

  factory UserClinicPoint.fromJson(Map<String, dynamic> json) {
    return UserClinicPoint(
      points: json['points'],
    );
  }
}
