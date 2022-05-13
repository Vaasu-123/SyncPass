import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/models/passmodel.dart';
import 'package:passwordmanager/resources/offlineStorage.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:passwordmanager/widgets/alert_dialog_box.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  CustomAlertDialogBox alertDialogBox = CustomAlertDialogBox();

  Future loadFromOnlinetoOffline() async {
    print("Online to offline");
    //works
    try {
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
    } catch (e) {
      await alertDialogBox.dialogBox(textToDisplay: "Some error occured");
      return;
    }
    await alertDialogBox.dialogBox(textToDisplay: "Successful");
    // print(await (await db.database).rawQuery(
    // 'SELECT * FROM $tablePasses ORDER BY ${passFields.websiteName} ASC'));
  }

  Future loadFromOfflinetoOnline() async {
    // print("Offline to online");
    //works
    try {
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
    } catch (e) {
      await alertDialogBox.dialogBox(textToDisplay: "Some error occured");
      return;
    }
    await alertDialogBox.dialogBox(textToDisplay: "Successful");
    // print("Congratulations");
  }

  Future addPassword({
    required password,
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
      alertDialogBox.dialogBox(textToDisplay: "Internet not working!");
      return;
    }
    // BuildContext ctx = BuildContext();
    await alertDialogBox.dialogBox(
        textToDisplay: "Password saved successfully!");
    // passModel passee = passModel(password: password, websiteName: website, uid: uid);
  }

  Future deletePass({required passId}) async {
    final user = FirebaseAuth.instance.currentUser;
    final db = await PasswordDatabase.instance;
    await db.database;
    db.delete(id: passId);
    try {
      await _firestore
          .collection('passes')
          .doc(user!.uid)
          .collection('passwords')
          .doc(passId)
          .delete();
    } catch (e) {
      print(e);
      alertDialogBox.dialogBox(textToDisplay: "Internet not working!");
      return;
    }
    // BuildContext ctx = BuildContext();
    alertDialogBox.dialogBox(textToDisplay: "Password deleted successfully!");
  }

  Future updateCredentials(
      {required passId, required password, required website}) async {
    final user = FirebaseAuth.instance.currentUser;
    PasswordDatabase pdoffline = PasswordDatabase.instance;
    await pdoffline.update(
      id: passId,
      password: password,
      website: website,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );
    try {
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
    } catch (e) {
      print(e);
      Navigator.of(navigatorKey.currentContext!).pop();
      alertDialogBox.dialogBox(textToDisplay: "Some error occured!");
      // print("yha aaya tha mein");
      return;
    }
    Navigator.of(navigatorKey.currentContext!).pop();
    // BuildContext ctx = BuildContext();
    alertDialogBox.dialogBox(textToDisplay: "Password edited successfully!");
  }
}
