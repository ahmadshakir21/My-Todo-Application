import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/screen/about_me.dart';
import 'package:todo_app/screen/edit_task.dart';
import 'package:todo_app/service/cloud_firestore.dart';
import 'package:todo_app/widget/drawer_item.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController taskNameController = TextEditingController();

  TextEditingController taskDescriptionController = TextEditingController();

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  // Future create() async {
  //   final taskCollection = FirebaseFirestore.instance.collection("task");

  //   final docRef = taskCollection.doc();

  //   await docRef.set({
  //     "taskName": taskNameController.text,
  //     "taskDescription": taskDescriptionController.text
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: [
            DrawerHeader(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF244395),
              ),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                          color: const Color(0xFFC3C3C3),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 75,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "theUserModel.name!",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "user!.email!",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            DrawerItems(
              icon: Icons.add_box_rounded,
              text: "Add Task",
              onClick: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        elevation: 5,
                        alignment: Alignment.center,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: SingleChildScrollView(
                          child: Container(
                            height: 430,
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Adding Your Task",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF244395)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                TextField(
                                  controller: taskNameController,
                                  decoration: InputDecoration(
                                      hintText: "Task Name",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
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
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Container(
                                  width: 135,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        CloudFirestore.create(TaskModel(
                                            taskName: taskNameController.text,
                                            taskDescription:
                                                taskDescriptionController
                                                    .text));

                                        taskNameController.text = "";
                                        taskDescriptionController.text = "";

                                        Navigator.pop(context);
                                      },
                                      // final firestoreInstance =
                                      //     FirebaseFirestore.instance;

                                      // TaskModel taskModel = TaskModel();

                                      // taskModel.title = taskNameController.text;
                                      // taskModel.bodyText =
                                      //     taskDescriptionController.text;

                                      // firestoreInstance
                                      //     .collection("task")
                                      //     .doc()
                                      //     .set(taskModel.toMap());
                                      // },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: Colors.indigo),
                                      child: const Text(
                                        "DONE",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      )),
                                ),
                              ]),
                            ),
                          ),
                        ));
                  },
                );
                scaffoldKey.currentState!.closeDrawer();
              },
            ),
            DrawerItems(
                icon: Icons.person,
                text: "About Me",
                onClick: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AboutMe();
                    },
                  ));
                }),
            DrawerItems(
              icon: Icons.logout,
              text: "Logout",
              onClick: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      elevation: 5,
                      alignment: Alignment.center,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 185,
                        width: 350,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Alert",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF244395)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Are you Sure want to Logout?",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF244395)),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          primary: Colors.indigo),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // Navigator.pop(context);
                                        // FirebaseAuth.instance.signOut();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          primary: const Color(0xFFE24047)),
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu_rounded,
                          size: 32,
                        )),
                    const Text(
                      "Home",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                StreamBuilder<List<TaskModel>>(
                    stream: CloudFirestore.readData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("Some error occured"));
                      } else if (snapshot.hasData) {
                        final taskData = snapshot.data;
                        return Container(
                          height: 615,
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: taskData!.length,
                            itemBuilder: (context, index) {
                              final singleData = taskData[index];
                              return Container(
                                width: double.infinity,
                                height: 175,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            singleData.taskName.toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) => EditTask(
                                                          taskForEdit: TaskModel(
                                                              id: singleData.id,
                                                              taskName:
                                                                  singleData
                                                                      .taskName,
                                                              taskDescription:
                                                                  singleData
                                                                      .taskDescription)),
                                                    ));
                                                  },
                                                  icon: const Icon(Icons.edit)),
                                              IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Dialog(
                                                          elevation: 5,
                                                          alignment:
                                                              Alignment.center,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Container(
                                                            height: 185,
                                                            width: 370,
                                                            child: Column(
                                                              children: [
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                const Text(
                                                                  "Delete Task",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          19,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      color: Color(
                                                                          0xFF244395)),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                const Text(
                                                                  "Are you Sure want to Delete this task ?",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Color(
                                                                          0xFF244395)),
                                                                ),
                                                                const SizedBox(
                                                                  height: 35,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          110,
                                                                      child: ElevatedButton(
                                                                          onPressed: () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), primary: Colors.indigo),
                                                                          child: const Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                          )),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          110,
                                                                      child: ElevatedButton(
                                                                          onPressed: () {
                                                                            CloudFirestore.delete(singleData).then((value) =>
                                                                                Navigator.pop(context));
                                                                          },
                                                                          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), primary: const Color(0xFFE24047)),
                                                                          child: const Text(
                                                                            "Delete",
                                                                            style:
                                                                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                                                          )),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    // Navigator.of(context)
                                                    //     .push(MaterialPageRoute(
                                                    //   builder: (context) => EditTask(
                                                    //       taskForEdit: TaskModel(
                                                    //           id: singleData.id,
                                                    //           taskName: singleData
                                                    //               .taskName,
                                                    //           taskDescription:
                                                    //               singleData
                                                    //                   .taskDescription)),
                                                    // ));
                                                  },
                                                  icon: const Icon(
                                                      Icons.delete_rounded)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(singleData.taskDescription
                                          .toString()),
                                    ]),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                    elevation: 5,
                    alignment: Alignment.center,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: SingleChildScrollView(
                      child: Container(
                        height: 430,
                        width: 350,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Adding Your Task",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF244395)),
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
                              height: 40,
                            ),
                            Container(
                              width: 135,
                              child: ElevatedButton(
                                  onPressed: () {
                                    CloudFirestore.create(TaskModel(
                                        taskName: taskNameController.text,
                                        taskDescription:
                                            taskDescriptionController.text));

                                    taskNameController.text = "";
                                    taskDescriptionController.text = "";

                                    Navigator.pop(context);
                                  },
                                  // final firestoreInstance =
                                  //     FirebaseFirestore.instance;

                                  // TaskModel taskModel = TaskModel();

                                  // taskModel.title = taskNameController.text;
                                  // taskModel.bodyText =
                                  //     taskDescriptionController.text;

                                  // firestoreInstance
                                  //     .collection("task")
                                  //     .doc()
                                  //     .set(taskModel.toMap());
                                  // },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      primary: Colors.indigo),
                                  child: const Text(
                                    "DONE",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  )),
                            ),
                          ]),
                        ),
                      ),
                    ));
              },
            );
          },
          backgroundColor: Colors.indigo,
          child: const Icon(
            Icons.add_rounded,
            size: 37,
          ),
        ),
      ),
    );
  }
}
