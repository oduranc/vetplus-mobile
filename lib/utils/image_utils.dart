import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vetplus/widgets/common/buttons_bottom_sheet.dart';

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

Future<dynamic> buildPickImageModal(BuildContext context,
    VoidCallback onGallerySelected, VoidCallback onCameraSelected) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return ButtonsBottomSheet(
        children: [
          ElevatedButton(
            onPressed: onGallerySelected,
            child: Text(AppLocalizations.of(context)!.selectFromGallery),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.black),
            ),
            onPressed: onCameraSelected,
            child: Text(AppLocalizations.of(context)!.takeWithCamera),
          ),
        ],
      );
    },
  );
}
