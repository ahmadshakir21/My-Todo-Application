import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uID;
  String? name;
  String? email;
  String? image;

  DocumentReference? reference;

  UserModel({this.uID, this.name, this.email, this.image});

  Map<String, dynamic> toMap() {
    return {
      "uID": uID,
      "name": name,
      "email": email,
      "image": image,
    };
  }

  factory UserModel.fromSnapShot(DocumentSnapshot documentSnapshot) {
    return UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>,
        reference: documentSnapshot.reference);
  }

  factory UserModel.fromMap(Map<String, dynamic> map,
      {required DocumentReference<Object?> reference}) {
    return UserModel(
      uID: map['uID'],
      name: map['name'],
      email: map['email'],
      image: map['image'],
    );
  }
}
