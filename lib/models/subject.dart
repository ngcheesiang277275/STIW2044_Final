class Subject {
  String? subjectId;
  String? subjectName;
  String? subjectDescription;
  String? subjectPrice;
  String? tutorId;
  String? subjectSessions;
  String? subjectRating;

  Subject(
      {this.subjectId,
      this.subjectName,
      this.subjectDescription,
      this.subjectPrice,
      this.tutorId,
      this.subjectSessions,
      this.subjectRating});

  Subject.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    subjectDescription = json['subjectDescription'];
    subjectPrice = json['subjectPrice'];
    tutorId = json['tutorId'];
    subjectSessions = json['subjectSessions'];
    subjectRating = json['subjectRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subjectId'] = subjectId;
    data['subjectName'] = subjectName;
    data['subjectDescription'] = subjectDescription;
    data['subjectPrice'] = subjectPrice;
    data['tutorId'] = tutorId;
    data['subjectSessions'] = subjectSessions;
    data['subjectRating'] = subjectRating;
    return data;
  }
}
