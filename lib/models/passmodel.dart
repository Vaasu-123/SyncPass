final String tablePasses = 'passwords';

class passFields {
  static final List<String> values = [
    uid,
    password,
    websiteName,
  ];

  static final String uid = "uid";
  static final String password = 'password';
  static final String websiteName = 'websiteName';
}

class passModel {
  final password;
  final websiteName;
  final uid;

  passModel({
    required this.password,
    required this.websiteName,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "password": password,
        "websiteName": websiteName,
        "uid": uid,
      };
}
