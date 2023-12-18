import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'common_utils.dart';

class ScanPhotoButton extends StatelessWidget {
  final Function(String) onImageSelected;

  const ScanPhotoButton({Key? key, required this.onImageSelected})
      : super(key: key);

  void pickAndCropImage(BuildContext context, ImageSource source) {
    CommonUtils.pickImage(source: source).then((value) {
      if (value != '') {
        CommonUtils.imageCropperView(value, context).then((croppedValue) {
          if (croppedValue != '') {
            onImageSelected(croppedValue);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        CommonUtils.imagePickerModal(
          context,
          onCameraTap: () {
            log("Camera");
            pickAndCropImage(context, ImageSource.camera);
          },
          onGalleryTap: () {
            log("Gallery");
            pickAndCropImage(context, ImageSource.gallery);
          },
        );
      },
      label: const Text("Scan photo"),
    );
  }
}
