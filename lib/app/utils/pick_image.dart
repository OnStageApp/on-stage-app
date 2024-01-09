
import 'package:image_picker/image_picker.dart';
import 'package:on_stage_app/logger.dart';

Future<XFile?> pickImage(ImageSource source) async{
  final  imagePicker = ImagePicker();
  final file = await imagePicker.pickImage(source: source);
  if(file != null){
   logger.i('Changed profile picture');
    return file;
  }

  return null;
}