import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';

class TaskModel {
  String? id;
  String? taskName;
  String? taskDescription;

  TaskModel({this.id, this.taskName, this.taskDescription});

  factory TaskModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return TaskModel(
        id: snapshot['id'],
        taskName: snapshot['taskName'],
        taskDescription: snapshot['taskDescription']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "taskName": taskName,
      "taskDescription": taskDescription,
    };
  }
}
