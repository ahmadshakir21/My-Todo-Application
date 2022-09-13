class TaskModel {
  String? uID;
  String? title;
  String? bodyText;

  TaskModel({this.uID, this.title, this.bodyText});

  Map<String, dynamic> toMap() {
    return {
      "uID": uID,
      "title": title,
      "bodyText": bodyText,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      uID: map['uID'],
      title: map['title'],
      bodyText: map['bodyText'],
    );
  }
}
