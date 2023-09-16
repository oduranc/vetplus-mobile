import 'package:flutter/cupertino.dart';
import 'package:vetplus/models/pet_model.dart';

class PetsProvider extends ChangeNotifier {
  List<PetModel>? _pets;

  List<PetModel>? get pets => _pets;

  void setPets(List<PetModel> pets) {
    _pets = pets;
    notifyListeners();
  }

  void clearPets() {
    _pets = null;
    notifyListeners();
  }
}
