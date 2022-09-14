import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/task_model.dart';

class CloudFirestore {
  static Future create(TaskModel taskModel) async {
    final taskCollection = FirebaseFirestore.instance.collection("task");

    final uID = taskCollection.doc().id;
    final docRef = taskCollection.doc(uID);

    // await docRef.set({
    //   "taskName": taskNameController.text,
    //   "taskDescription": taskDescriptionController.text
    // });

    final task = TaskModel(
            id: uID,
            taskName: taskModel.taskName,
            taskDescription: taskModel.taskDescription)
        .toJson();

    try {
      await docRef.set(task);
    } catch (error) {
      print(error);
    }
  }

  static Stream<List<TaskModel>> readData() {
    final taskCollection = FirebaseFirestore.instance.collection("task");

    return taskCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => TaskModel.fromSnapshot(e)).toList());
  }

  static Future update(TaskModel taskModel) async {
    final taskCollection = FirebaseFirestore.instance.collection("task");

    final docRef = taskCollection.doc(taskModel.id);

    final task = TaskModel(
            id: taskModel.id,
            taskName: taskModel.taskName,
            taskDescription: taskModel.taskDescription)
        .toJson();

    try {
      await docRef.update(task);
    } catch (error) {
      print(error);
    }
  }

  static Future delete(TaskModel taskModel) async {
    final taskCollection = FirebaseFirestore.instance.collection("task");

    final docRef = taskCollection.doc(taskModel.id).delete();

    // final task = TaskModel(
    //         id: taskModel.id,
    //         taskName: taskModel.taskName,
    //         taskDescription: taskModel.taskDescription)
    //     .toJson();
  }
}
