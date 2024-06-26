import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<XFile?> getImage() async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  return image;
}

final FirebaseStorage storage = FirebaseStorage.instance;

Future<Object> uploadImage(File image) async {
  try {
    final String namefile = image.path.split('/').last;
    final Reference ref = storage.ref().child('products').child(namefile);
    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    final String url = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      return url;
    } else {
      return Null;
    }
  } catch (e) {
    print(e);
    return Null;
  }
}
