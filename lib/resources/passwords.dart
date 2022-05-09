import 'package:uuid/uuid.dart';

class Passwords{
  String generatePasswords(){
    String gen_pass = const Uuid().v1();
    return gen_pass;
  }
}