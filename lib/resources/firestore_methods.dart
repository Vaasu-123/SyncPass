import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passwordmanager/models/passmodel.dart';
import 'package:passwordmanager/resources/offlineStorage.dart';
import 'package:passwordmanager/resources/storing_uid.dart';
import 'package:passwordmanager/utils/colors.dart';
import 'package:passwordmanager/widgets/alert_dialog_box.dart';
import 'package:uuid/uuid.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../main.dart';
import '../utils/custom_exception.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  CustomAlertDialogBox alertDialogBox = CustomAlertDialogBox();
  bool internetAvailable = false;

  Future internetCheck() async {
    internetAvailable = await InternetConnectionChecker().hasConnection;
  }

  throwException() {
    throw CustomException('This is my first custom exception');
  }

  Future loadFromOnlinetoOffline() async {
    print("Online to offline");
    //works
    try {
      await internetCheck();

      if (internetAvailable == true) {
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
          await db.deleteAll(userId: await UserSecureStorage.getUserId());
          print("object");
          for (var item in passes.docs) {
            passModel pass = passModel(
              password: item['password'],
              websiteName: item['websiteName'],
              uid: item['uid'],
            );
            db.create(pass: pass, userId: await UserSecureStorage.getUserId());
          }
        }
      } else {
        print("I ran");
        throwException();
      }
    } on CustomException {
      await alertDialogBox.dialogBox(textToDisplay: "No Internet!");
      return;
    } catch (e) {
      await alertDialogBox.dialogBox(textToDisplay: "Some error occured");
      return;
    }
    print(internetAvailable);
    await alertDialogBox.dialogBox(textToDisplay: "Successful");
    print(await (await PasswordDatabase.instance.database).rawQuery(
        'SELECT * FROM $tablePasses ORDER BY ${passFields.websiteName} ASC'));
  }

  Future loadFromOfflinetoOnline({bool firstTime = false}) async {
    // print("Offline to online");
    //works
    try {
      await internetCheck();
      if (internetAvailable == true) {
        final List db = await PasswordDatabase.instance
            .getAll(userId: await UserSecureStorage.getUserId());
        print("Idhar toh aa gyaaaaa");

        if (db.isNotEmpty) {
          print(db);
          print("Idhar toh aa gyas");
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
        } else {
          // print("idhar bhi");
          final allData = await _firestore
              .collection('passes')
              .doc(user!.uid)
              .collection('passwords')
              .get();
          if (allData != []) {
            for (var item in allData.docs) {
              // passModel pass = passModel(
              //   password: item['password'],
              //   websiteName: item['websiteName'],
              //   uid: item['uid'],
              // );
              await _firestore
              .collection('passes')
              .doc(user!.uid)
              .collection('passwords')
              .doc(item['uid']).delete();
            }
          }
        }
      } else {
        // print("I ran");
        throwException();
      }
    } on CustomException {
      if (!firstTime) {
        await alertDialogBox.dialogBox(textToDisplay: "No Internet!");
        return;
      }
    } catch (e) {
      if (!firstTime) {
        await alertDialogBox.dialogBox(textToDisplay: "Some error occured");
        return;
      }
    }
    if (!firstTime) {
      print("specific to this");
      await alertDialogBox.dialogBox(textToDisplay: "Successful");
    }
    // print("First run");
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
    await PasswordDatabase.instance
        .create(pass: pass, userId: await UserSecureStorage.getUserId());
    try {
      await internetCheck();
      
      if (internetAvailable == true) {
        print("idhar bhi");
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
      } else {
        print("I ran");
        throwException();
      }
    } on CustomException {
      Navigator.of(navigatorKey.currentContext!).pop();
      await alertDialogBox.dialogBox(textToDisplay: "No Internet!");
      return;
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
    print("delete executed");
    final user = FirebaseAuth.instance.currentUser;
    final db = await PasswordDatabase.instance;
    await db.database;
    await db.delete(id: passId);
    try {
      await internetCheck();
      if (internetAvailable == true) {
        await _firestore
            .collection('passes')
            .doc(user!.uid)
            .collection('passwords')
            .doc(passId)
            .delete();
      } else {
        print("I ran");
        throwException();
      }
    } on CustomException {
      await alertDialogBox.dialogBox(textToDisplay: "No Internet!");
      return;
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
      userId: await UserSecureStorage.getUserId(),
    );
    try {
      await internetCheck();
      if (internetAvailable == true) {
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
      } else {
        print("I ran");
        throwException();
      }
    } on CustomException {
      Navigator.of(navigatorKey.currentContext!).pop();
      await alertDialogBox.dialogBox(textToDisplay: "No Internet!");
      return;
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
