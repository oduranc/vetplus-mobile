import 'dart:io';

import 'package:image_picker/image_picker.dart';

// Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//   if (files != null) {
//     _handleLostFiles(files);
//   } else {
//     _handleError(response.exception);
//   }
// }

Future<File?> pickImage(ImageSource source) async {
  final XFile? returnedImage = await ImagePicker().pickImage(source: source);

  if (returnedImage == null) return null;
  return File(returnedImage.path);
}
