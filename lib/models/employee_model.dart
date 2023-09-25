class EmployeeList {
  List<EmployeeModel> list;

  EmployeeList({
    required this.list,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      list: List<EmployeeModel>.from(
          json['getAllEmployee'].map((x) => EmployeeModel.fromJson(x))),
    );
  }
}

class EmployeeModel {
  final String idClinic;
  final String idEmployee;
  final String employeeInvitationStatus;
  final String createdAt;
  final String updatedAt;
  final bool status;
  final EmployeeData employee;

  EmployeeModel({
    required this.idClinic,
    required this.idEmployee,
    required this.employeeInvitationStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.employee,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final employeeData = EmployeeData.fromJson(json['Employee']);

    return EmployeeModel(
      idClinic: json['id_clinic'],
      idEmployee: json['id_employee'],
      employeeInvitationStatus: json['employee_invitation_status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      employee: employeeData,
    );
  }
}

class EmployeeData {
  final String names;
  final String? surnames;
  final String? image;
  final String email;
  final bool status;

  EmployeeData({
    required this.names,
    this.surnames,
    this.image,
    required this.email,
    required this.status,
  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      names: json['names'],
      surnames: json['surnames'],
      image: json['image'],
      email: json['email'],
      status: json['status'],
    );
  }
}
