import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passwordmanager/models/passmodel.dart';
import 'package:passwordmanager/resources/offlineStorage.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future addPassword(
      {required password, required website, required uid}) async {
    final uidd = Uuid().v1();
    passModel pass = passModel(
      password: password,
      websiteName: website,
      uid: uidd,
    );

    // await PasswordDatabase.instance.database;
    print("Check");
    //print(PasswordDatabase.instance.database);
    await PasswordDatabase.instance.create(pass: pass);

    final passes = await _firestore.collection('passes').doc(uid).get();
    if (passes.exists) {
      await _firestore
          .collection('passes')
          .doc(uid)
          .collection('passwords')
          .doc(uidd)
          .update(pass.toJson());
      print("Hi there");
    } else {
      await _firestore
          .collection('passes')
          .doc(uid)
          .collection('passwords')
          .doc(uidd)
          .set(pass.toJson());
      print("Something");
    }

    // passModel passee = passModel(password: password, websiteName: website, uid: uid);
  }

  Future deletePass({required passId}) async {
    final user = FirebaseAuth.instance.currentUser;

    await _firestore
        .collection('passes')
        .doc(user!.uid)
        .collection('passwords')
        .doc(passId)
        .delete();
  }

  Future updateCredentials(
      {required passId, required password, required website}) async {
    final user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection('passes')
        .doc(user!.uid)
        .collection('passwords')
        .doc(passId)
        .update(
      {
        'password': password,
        'websiteName': website,
      },
    );
  }
}
