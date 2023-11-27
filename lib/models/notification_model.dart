class NotificationList {
  List<NotificationModel> list;

  NotificationList({
    required this.list,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) =>
      NotificationList(
        list: List<NotificationModel>.from(json['getAllNotification']
            .map((x) => NotificationModel.fromJson(x))),
      );
}

class NotificationModel {
  final String id;
  final String idUser;
  final String title;
  final String subtitle;
  final String category;
  final bool read;
  final String createdAt;
  final String updatedAt;
  final bool status;

  NotificationModel({
    required this.id,
    required this.idUser,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      idUser: json['id_user'],
      title: json['title'],
      subtitle: json['subtitle'],
      category: json['category'],
      read: json['read'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}
