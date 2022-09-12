class TaskModel {
  String? uID;
  String? title;
  String? bodyText;
  DateTime? date;

  TaskModel({this.uID, this.title, this.bodyText, this.date});

  Map<String, dynamic> toMap() {
    return {
      "uID": uID,
      "title": title,
      "bodyText": bodyText,
      "date": date,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      uID: map['uID'],
      title: map['title'],
      bodyText: map['bodyText'],
      date: map['date'],
    );
  }
}
