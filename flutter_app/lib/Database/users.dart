import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  Users(
      {this.mobile,
      this.firstName,
      this.lastName,
      this.emailId,
      this.gender,
      this.bloodGroup,
      this.dob,
      this.eCont1,
      this.eCont2,
      this.eCont3});

  String mobile;
  String firstName;
  String lastName;
  String emailId;
  String gender;
  String bloodGroup;
  String dob;
  String eCont1;
  String eCont2;
  String eCont3;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        mobile: json["mobile"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        emailId: json["email_id"],
        gender: json["gender"],
        bloodGroup: json["blood_group"],
        dob: json["dob"],
        eCont1: json["e_cont1"],
        eCont2: json["e_cont2"],
        eCont3: json["e_cont3"],
      );

  Map<String, dynamic> toJson() => {
        "mobile": mobile,
        "first_name": firstName,
        "last_name": lastName,
        "email_id": emailId,
        "gender": gender,
        "blood_group": bloodGroup,
        "dob": dob,
        "e_cont1": eCont1,
        "e_cont2": eCont2,
        "e_cont3": eCont3,
      };
}
