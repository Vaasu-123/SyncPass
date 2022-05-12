import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/models/passmodel.dart';
import 'package:passwordmanager/resources/offlineStorage.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Future loadFromOnlinetoOffline() async {
    print("Online to offline");
    //works
    final passes = await _firestore
        .collection('passes')
        .doc(user!.uid)
        .collection('passwords')
        .get();
    print(passes.docs);
    final db = await PasswordDatabase.instance;
    await db.database;
    if (passes != []) {
      print("yha aaya tha");
      await db.deleteAll(userId: user!.uid);
      print("object");
      for (var item in passes.docs) {
        passModel pass = passModel(
          password: item['password'],
          websiteName: item['websiteName'],
          uid: item['uid'],
        );
        db.create(pass: pass, userId: user!.uid);
      }
    }
    print(await (await db.database).rawQuery(
        'SELECT * FROM $tablePasses ORDER BY ${passFields.websiteName} ASC'));
  }

  Future loadFromOfflinetoOnline() async {
    print("Offline to online");
    //works
    final List db = await PasswordDatabase.instance.getAll(userId: user!.uid);
    print("Idhar toh aa gya");
    if (db != []) {
      for (Map item in db) {
        passModel pass = passModel(
          password: item['password'],
          websiteName: item['websiteName'],
          uid: item['uid'],
        );
        // final passes = await _firestore.collection('passes').doc(uid).get();
        await _firestore
            .collection('passes')
            .doc(user!.uid)
            .collection('passwords')
            .doc(item['uid'])
            .set(pass.toJson());
      }
    }
    print("Congratulations");
  }

  Future addPassword(
      {required password,
      required website,
      required uid,
      }) async {

        print("hann bro m runnin");
    final uidd = Uuid().v1();
    passModel pass = passModel(
      password: password,
      websiteName: website,
      uid: uidd,
    );
    await PasswordDatabase.instance.create(pass: pass, userId: user!.uid);
    try {
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
    } catch (e) {
      print(e);
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Internet not working'),
        ),
      );
    }
    // BuildContext ctx = BuildContext();
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (_) => AlertDialog(
        title: Text('Successful'),
        content: Text('Password saved succesfully'),
      ),
    );

    // passModel passee = passModel(password: password, websiteName: website, uid: uid);
  }

  Future deletePass({required passId}) async {
    final user = FirebaseAuth.instance.currentUser;
    final db = await PasswordDatabase.instance;
    await db.database;
    db.delete(id: passId);
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
