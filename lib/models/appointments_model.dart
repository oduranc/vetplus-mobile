import 'package:vetplus/models/clinic_model.dart';
import 'package:vetplus/models/pet_model.dart';

class AppointmentList {
  List<AppointmentDetails> getAppointmentDetails;

  AppointmentList({required this.getAppointmentDetails});

  factory AppointmentList.fromJson(Map<String, dynamic> json) {
    return AppointmentList(
        getAppointmentDetails: List<AppointmentDetails>.from(
            json['getAppointmentDetailAllRoles']
                .map((x) => AppointmentDetails.fromJson(x))));
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
  String? observations;
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
      observations: json['observations'],
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

class Clinic {
  String id;
  String idOwner;
  String name;
  String telephoneNumber;
  String? googleMapsUrl;
  String? email;
  String? image;
  String address;
  String createdAt;
  String updatedAt;
  bool status;

  Clinic({
    required this.id,
    required this.idOwner,
    required this.name,
    required this.telephoneNumber,
    required this.googleMapsUrl,
    required this.email,
    required this.image,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      idOwner: json['id_owner'],
      name: json['name'],
      telephoneNumber: json['telephone_number'],
      googleMapsUrl: json['google_maps_url'],
      email: json['email'],
      image: json['image'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      status: json['status'],
    );
  }
}

class Pet {
  String id;
  String idOwner;
  int idSpecie;
  int idBreed;
  String name;
  String? image;
  String gender;
  bool castrated;
  String? dob;
  String? observations;
  String createdAt;
  String updatedAt;
  bool status;

  Pet({
    required this.id,
    required this.idOwner,
    required this.idSpecie,
    required this.idBreed,
    required this.name,
    required this.image,
    required this.gender,
    required this.castrated,
    required this.dob,
    required this.observations,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
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
    );
  }
}

class Veterinarian {
  String id;
  String names;
  String? surnames;
  String email;
  String provider;
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
  String email;
  String provider;
  String document;
  String address;
  String telephoneNumber;
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
