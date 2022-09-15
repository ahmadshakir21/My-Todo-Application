import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/service/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  const EditTask({Key? key, required this.taskForEdit}) : super(key: key);

  final TaskModel taskForEdit;

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController? taskNameController;

  TextEditingController? taskDescriptionController;

  @override
  void initState() {
    taskNameController =
        TextEditingController(text: widget.taskForEdit.taskName);
    taskDescriptionController =
        TextEditingController(text: widget.taskForEdit.taskDescription);
    super.initState();
  }

  @override
  void dispose() {
    taskNameController!.dispose();
    taskDescriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0B2E40),
                      size: 32,
                    )),
                const SizedBox(
                  width: 80,
                ),
                const Text(
                  "Edit Task",
                  style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF0B2E40),
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(
                  hintText: "Task Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: 7,
              controller: taskDescriptionController,
              decoration: InputDecoration(
                  hintText: "Task Description",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      CloudFirestore.update(
                        TaskModel(
                            id: widget.taskForEdit.id,
                            taskName: taskNameController!.text,
                            taskDescription: taskDescriptionController!.text),
                      ).then((value) => {Navigator.pop(context)});
                    },
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0B2E40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    child: const Text(
                      "Update",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ))),
          ]),
        ),
      )),
    );
  }
}
