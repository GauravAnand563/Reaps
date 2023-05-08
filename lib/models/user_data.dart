class UserData {
  final String firstName;
  final String lastName;
  final String email;
  final int? grade;
  final String? subjectPreferred;
  final bool isRegistrationCompleted;

  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.grade,
    this.subjectPreferred,
    this.isRegistrationCompleted = false,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      email: json["email"] as String,
      grade: json["grade"] as int?,
      subjectPreferred: json["subject_preferred"] as String?,
      isRegistrationCompleted:
          json["grade"] != null && json["subject_preferred"] != null);

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "grade": grade,
        "subject_preferred": subjectPreferred,
        "isRegistrationCompleted": isRegistrationCompleted,
      };

  @override
  String toString() {
    return 'UserData(firstName: $firstName, lastName: $lastName, email: $email, grade: $grade, subjectPreferred: $subjectPreferred, isRegistrationCompleted: $isRegistrationCompleted)';
  }
}
