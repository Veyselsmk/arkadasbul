import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:friend_circle/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  late firebase_storage.Reference _storageReference;


  @override
  Future<String?> uploadFile(String? userID, String? fileType, File file) async {
    _storageReference = firebase_storage.FirebaseStorage.instance.ref().child(userID!).child(fileType!).child("profil_foto.png");

    firebase_storage.UploadTask uploadTask = _storageReference.putFile(file);

    firebase_storage.TaskSnapshot snapshot = await uploadTask;

    var url = await _storageReference.getDownloadURL();
    return url;


    /*Reference? imgRef = await firebaseStorage.ref().child(userID!).child(fileType!);
    final metadata = SettableMetadata(contentType: "image/png");
    UploadTask uploadTask = imgRef.putFile(file, metadata);
    firebaseStorage.TaskSnapshot snapshot = await uploadTask;
*/
    /*TaskSnapshot uploadSnapshot = uploadTask.snapshot;
    if(uploadSnapshot.state == TaskState.success) {
      String? url = await uploadSnapshot.ref.getDownloadURL();
      return url;
    }*/
    //await (await uploadTask).ref.getDownloadURL();
  }
}
