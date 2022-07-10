class Tutor {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorPassword;
  String? tutorDescription;
  String? tutorDatereg;

  Tutor(
      {this.tutorId,
      this.tutorEmail,
      this.tutorPhone,
      this.tutorName,
      this.tutorPassword,
      this.tutorDescription,
      this.tutorDatereg});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutorId'];
    tutorEmail = json['tutorEmail'];
    tutorPhone = json['tutorPhone'];
    tutorName = json['tutorName'];
    tutorPassword = json['tutorPassword'];
    tutorDescription = json['tutorDescription'];
    tutorDatereg = json['tutorDatereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutorId'] = tutorId;
    data['tutorEmail'] = tutorEmail;
    data['tutorPhone'] = tutorPhone;
    data['tutorName'] = tutorName;
    data['tutorPassword'] = tutorPassword;
    data['tutorDescription'] = tutorDescription;
    data['tutorDatereg'] = tutorDatereg;
    return data;
  }
}
