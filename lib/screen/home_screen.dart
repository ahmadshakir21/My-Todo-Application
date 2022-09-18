import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/model/user.dart';
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

  User? user = FirebaseAuth.instance.currentUser;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  late String fileName;
  String imageUrl = "";

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile image;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //select images
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      var file = File(image?.path as String);
      fileName = basename(file.path);
      if (image != null) {
        //upload image to firebase
        var snapshot = await FirebaseStorage.instance
            .ref()
            .child("profile")
            .child(FirebaseAuth.instance.currentUser!.uid +
                "_" +
                basename(file.path))
            .putFile(file);
        var downlodeURL = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downlodeURL;
        });

        Map<String, dynamic> map = Map();
        if (fileName != null) {
          String url = downlodeURL;
          map['image'] = url;
        }
        var uplod = await FirebaseFirestore.instance
            .collection("user")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(map);
        // Get.snackbar("Profile Image", "Your profile image is update");
      } else {
        print("No Image Path Recived");
      }
    } else {
      print("Permission not granted. Try Again with permission access");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("user").doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error...", style: GoogleFonts.poppins());
          } else if (snapshot.data == null) {
            return Text("Data is null", style: GoogleFonts.poppins());
          }

          UserModel userModel =
              UserModel.fromSnapShot(snapshot.data as DocumentSnapshot);

          return SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              drawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
                  DrawerHeader(
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0B2E40),
                    ),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Container(
                              //   height: 75,
                              //   width: 75,
                              //   decoration: BoxDecoration(
                              //       color: const Color(0xFFC3C3C3),
                              //       borderRadius: BorderRadius.circular(10)),
                              // ),

                              // Container(
                              //   height: 40,
                              //   width: 40,
                              //   child: FadeInImage(
                              //       placeholder:
                              //           AssetImage('assets/images/man.png'),
                              //       image: NetworkImage(userModel.image!),
                              //       imageErrorBuilder:
                              //           (ctx, exception, stackTrace) {
                              //         return ClipRRect(
                              //           borderRadius: BorderRadius.circular(10),
                              //           child: Container(
                              //             height: 40,
                              //             width: 40,
                              //             decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(20),
                              //             ),
                              //             child: Image.asset(
                              //               'assets/images/man.png',
                              //               fit: BoxFit.cover,
                              //             ),
                              //           ),
                              //         );
                              //       }),
                              // ),

                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: userModel.image!.isEmpty
                                      ? Container(
                                          height: 75,
                                          width: 75,
                                          color: const Color.fromARGB(
                                              255, 34, 76, 97),
                                        )
                                      : Image.network(
                                          userModel.image!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),

                              // userModel.image != null
                              //     ? ClipRRect(
                              //         borderRadius: BorderRadius.circular(10),
                              //         child: Container(
                              //           height: 75,
                              //           width: 75,
                              //           decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(20)),
                              //           child: Image.network(
                              //             userModel.image!,
                              //             fit: BoxFit.cover,
                              //           ),
                              //         ),
                              //       )
                              //     : ClipRRect(
                              //         borderRadius: BorderRadius.circular(10),
                              //         child: Container(
                              //           height: 75,
                              //           width: 75,
                              //           decoration: BoxDecoration(
                              //               borderRadius:
                              //                   BorderRadius.circular(20)),
                              //           child: Image.asset(
                              //             "assets/images/man.png",
                              //             fit: BoxFit.cover,
                              //           ),
                              //         ),
                              //       ),

                              IconButton(
                                  onPressed: uploadImage,
                                  icon: const Icon(
                                    Icons.add_circle_rounded,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.name!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                  // style: const TextStyle(
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.w500,
                                  //     color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  user!.email!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      letterSpacing: 1,
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
                                  height: 475,
                                  width: 350,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Adding Your Task",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0B2E40)),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      TextField(
                                        controller: taskNameController,
                                        style: GoogleFonts.poppins(),
                                        decoration: InputDecoration(
                                            hintText: "Task Name",
                                            hintStyle: GoogleFonts.poppins(),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      TextField(
                                        maxLines: 7,
                                        style: GoogleFonts.poppins(),
                                        controller: taskDescriptionController,
                                        decoration: InputDecoration(
                                            hintText: "Task Description",
                                            hintStyle: GoogleFonts.poppins(),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Container(
                                        width: 135,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              CloudFirestore.create(TaskModel(
                                                  taskName:
                                                      taskNameController.text,
                                                  taskDescription:
                                                      taskDescriptionController
                                                          .text));

                                              taskNameController.text = "";
                                              taskDescriptionController.text =
                                                  "";

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
                                                        BorderRadius.circular(
                                                            10)),
                                                primary:
                                                    const Color(0xFF0B2E40)),
                                            child: Text(
                                              "DONE",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500,
                                              ),
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
                            return const AboutMe();
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
                              height: 230,
                              width: 350,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Alert",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0B2E40)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Are you Sure want to Logout?",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF0B2E40)),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                      BorderRadius.circular(
                                                          20)),
                                              primary: const Color(0xFF0B2E40)),
                                          child: Text("Cancel",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              FirebaseAuth.instance.signOut();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                primary:
                                                    const Color(0xFFE24047)),
                                            child: Text(
                                              "Logout",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500,
                                              ),
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
                                size: 35,
                                color: Color(0xFF0B2E40),
                              )),
                          Text(
                            "Home",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0B2E40)),
                          ),
                          // Container(
                          //   height: 40,
                          //   width: 40,
                          //   decoration: BoxDecoration(
                          //       color: Colors.indigo,
                          //       borderRadius: BorderRadius.circular(10)),
                          // ),

                          // Container(
                          //   height: 75,
                          //   width: 75,
                          //   child: FadeInImage(
                          //     placeholder: AssetImage('assets/images/man.png'),
                          //     image: NetworkImage(userModel.image!),
                          //     imageErrorBuilder: (ctx, exception, stackTrace) {
                          //       return ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: Container(
                          //           height: 40,
                          //           width: 40,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(20),
                          //           ),
                          //           child: Image.asset(
                          //             'assets/images/man.png',
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),

                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    elevation: 7,
                                    alignment: Alignment.center,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 315,
                                        width: 315,
                                        color: const Color(0xFF0B2E40),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Container(
                                                  height: 315,
                                                  width: 315,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Container(
                                                      height: 45,
                                                      width: 45,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: userModel
                                                              .image!.isEmpty
                                                          ? Container(
                                                              height: 75,
                                                              width: 75,
                                                              color: const Color(
                                                                  0xFF0B2E40),
                                                            )
                                                          : Image.network(
                                                              userModel.image!,
                                                              fit: BoxFit.cover,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: userModel.image!.isEmpty
                                    ? Container(
                                        height: 75,
                                        width: 75,
                                        color: const Color(0xFF0B2E40),
                                      )
                                    : Image.network(
                                        userModel.image!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),

                          // userModel.image != null
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: Container(
                          //           height: 45,
                          //           width: 45,
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(20)),
                          //           child: Image.network(
                          //             userModel.image!,
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       )
                          //     : ClipRRect(
                          //         borderRadius: BorderRadius.circular(10),
                          //         child: Container(
                          //           height: 75,
                          //           width: 75,
                          //           decoration: BoxDecoration(
                          //               borderRadius:
                          //                   BorderRadius.circular(20)),
                          //           child: Image.asset(
                          //             "assets/images/man.png",
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      StreamBuilder<List<TaskModel>>(
                          stream: CloudFirestore.readData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                "Some error occured",
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red),
                              ));
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
                                      // height: 200,
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 20,
                                          left: 10,
                                          right: 10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.amber.shade700,
                                              Colors.orange.shade400
                                              // Colors.deepPurple
                                              //     .withOpacity(0.9),
                                              // Colors.deepPurple
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  singleData.taskName
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) => EditTask(
                                                                taskForEdit: TaskModel(
                                                                    id: singleData
                                                                        .id,
                                                                    taskName:
                                                                        singleData
                                                                            .taskName,
                                                                    taskDescription:
                                                                        singleData
                                                                            .taskDescription)),
                                                          ));
                                                        },
                                                        icon: const Icon(
                                                          Icons.edit,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Dialog(
                                                                elevation: 5,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                child:
                                                                    Container(
                                                                  height: 220,
                                                                  width: 370,
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        "Delete Task",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                18,
                                                                            letterSpacing:
                                                                                1,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: const Color(0xFF0B2E40)),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 5),
                                                                        child:
                                                                            Text(
                                                                          "Are you Sure want to Delete this task ?",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              letterSpacing: 1,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: const Color(0xFF0B2E40)),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            35,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                110,
                                                                            child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), primary: const Color(0xFF0B2E40)),
                                                                                child: Text(
                                                                                  "Cancel",
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                110,
                                                                            child: ElevatedButton(
                                                                                onPressed: () {
                                                                                  CloudFirestore.delete(singleData).then((value) => Navigator.pop(context));
                                                                                },
                                                                                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), primary: const Color(0xFFE24047)),
                                                                                child: Text(
                                                                                  "Delete",
                                                                                  style: GoogleFonts.poppins(
                                                                                    fontSize: 14,
                                                                                    letterSpacing: 1,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
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
                                                          Icons.delete_rounded,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              singleData.taskDescription
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF0B2E40)),
                                            ),
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
                              height: 475,
                              width: 350,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Adding Your Task",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF0B2E40)),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    controller: taskNameController,
                                    style: GoogleFonts.poppins(),
                                    decoration: InputDecoration(
                                        hintText: "Task Name",
                                        hintStyle: GoogleFonts.poppins(),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  TextField(
                                    maxLines: 7,
                                    style: GoogleFonts.poppins(),
                                    controller: taskDescriptionController,
                                    decoration: InputDecoration(
                                        hintText: "Task Description",
                                        hintStyle: GoogleFonts.poppins(),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  const SizedBox(
                                    height: 25,
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
                                            primary: const Color(0xFF0B2E40)),
                                        child: Text(
                                          "DONE",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                          ));
                    },
                  );
                },
                backgroundColor: const Color(0xFF0B2E40),
                child: const Icon(
                  Icons.add_rounded,
                  size: 37,
                ),
              ),
            ),
          );
        });
  }
}
