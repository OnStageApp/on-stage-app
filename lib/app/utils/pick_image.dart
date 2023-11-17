import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(ImageSource source) async{
  final  imagePicker = ImagePicker();
  XFile? _file = await imagePicker.pickImage(source: source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  print('No Images Selected');
  return null;
}