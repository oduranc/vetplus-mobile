import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/pet_model.dart';

class AppointmentList {
  List<AppointmentDetails> getAppointmentDetails;

  AppointmentList({required this.getAppointmentDetails});

  factory AppointmentList.fromJson(
      Map<String, dynamic> json, String objectName) {
    return AppointmentList(
        getAppointmentDetails: List<AppointmentDetails>.from(
            json[objectName].map((x) => AppointmentDetails.fromJson(x))));
  }
}

class AppointmentDetails {
  String startAt;
  String? endAt;
  String id;
  String idOwner;
  String idVeterinarian;
  String idPet;
  List<String> services;
  String idClinic;
  Observations observations;
  String? appointmentStatus;
  String state;
  String createdAt;
  String updatedAt;
  bool status;
  ClinicModel clinic;
  PetModel pet;
  Veterinarian veterinarian;
  Owner? owner;

  AppointmentDetails({
    required this.startAt,
    required this.endAt,
    required this.id,
    required this.idOwner,
    required this.idVeterinarian,
    required this.idPet,
    required this.services,
    required this.idClinic,
    required this.observations,
    required this.appointmentStatus,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.clinic,
    required this.pet,
    required this.veterinarian,
    required this.owner,
  });

  factory AppointmentDetails.fromJson(Map<String, dynamic> json) {
    return AppointmentDetails(
      startAt: json['start_at'],
      endAt: json['end_at'],
      id: json['id'],
      idOwner: json['id_owner'],
      idVeterinarian: json['id_veterinarian'],
      idPet: json['id_pet'],
      services: List<String>.from(json['services']),
      idClinic: json['id_clinic'],
      observations: Observations.fromJson(json['observations']),
      appointmentStatus: json['appointment_status'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
      clinic: ClinicModel.fromJson(json['Clinic']),
      pet: PetModel.fromJson(json['Pet']),
      veterinarian: Veterinarian.fromJson(json['Veterinarian']),
      owner: json['Owner'] != null ? Owner.fromJson(json['Owner']) : null,
    );
  }
}

class Observations {
  List<dynamic>? suffering;
  String? treatment;
  String? feed;

  Observations({this.suffering, this.treatment, this.feed});

  factory Observations.fromJson(Map<String, dynamic> json) {
    return Observations(
      suffering: json['suffering'],
      treatment: json['treatment'],
      feed: json['feed'],
    );
  }
}

class Veterinarian {
  String id;
  String names;
  String? surnames;
  String? email;
  String? provider;
  String? document;
  String? address;
  String? telephoneNumber;
  String? image;
  String? role;
  String createdAt;
  String updatedAt;
  bool status;

  Veterinarian({
    required this.id,
    required this.names,
    required this.surnames,
    required this.email,
    required this.provider,
    required this.document,
    required this.address,
    required this.telephoneNumber,
    required this.image,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Veterinarian.fromJson(Map<String, dynamic> json) {
    return Veterinarian(
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

class Owner {
  String id;
  String names;
  String? surnames;
  String? email;
  String? provider;
  String? document;
  String? address;
  String? telephoneNumber;
  String? image;
  String role;
  String createdAt;
  String updatedAt;
  bool status;

  Owner({
    required this.id,
    required this.names,
    required this.surnames,
    required this.email,
    required this.provider,
    required this.document,
    required this.address,
    required this.telephoneNumber,
    required this.image,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
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
