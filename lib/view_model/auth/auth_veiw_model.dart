import 'dart:developer';

import 'package:easysugar/help/constant.dart';
import 'package:easysugar/help/routs/routs_name.dart';
import 'package:easysugar/model/doctor.dart';
import 'package:easysugar/model/follower.dart';
import 'package:easysugar/model/rebort.dart';
import 'package:easysugar/model/survey.dart';
import 'package:easysugar/view/screens/authentication/follower_screen.dart';
import 'package:easysugar/view/screens/patient_home_screen.dart';
import 'package:easysugar/view_model/auth/auth.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../help/notifications.dart';
import '../../model/users.dart';

class AuthVeiwModel extends GetxController {
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  String? userType;
  UserModel? user;
  Follower? _follower;
  String? patientId;
  String? shortAction = 'Actrapid';
  String? longAction = 'Gensulin N';

  void changePasswordVisibility() {
    isPassword = !isPassword;
    update();
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    update();
  }

  Future<void> getUserData() async {
    log(box.read('patientId'));
    User? userF = FirebaseAuth.instance.currentUser;
    if (box.read('userType') == 'Follower') {
      UserModel? userModel =
          await FirestoreModel.use<UserModel>().find(box.read('patientId'));
      user = userModel;
      update();
      log("userModel ${user?.toMap}");
    }
    if (userF != null) {
      UserModel? userModel =
          await FirestoreModel.use<UserModel>().find(userF.uid);
      //log("uid ${userModel.uId}");
      user = userModel;
      update();

      log("userF ${userF}");
      log("userModel ${user?.toMap}");

      log("stateUserId ${user?.docId}");
    }
  }

  logOutInFollower() async {
    box.remove('patientId');
    Get.to(FollowerScreen());
    log('follower ${_follower?.docId}');
  }

  String? followerId;

  signInAsFollower({String? phoneNum, patientCode, name}) async {
    log('id $patientCode');
    UserModel? userModel =
        await FirestoreModel.use<UserModel>().find(patientCode);
    log('user ${userModel?.toMap}');
    user = userModel;
    update();
    // bool? isFollow =
    //     await user?.subCollection<Follower>().exists(box.read('patientId'));
    // log('isFollow $isFollow');
    // if (isFollow == true) {
    //   Get.to(() => HomeScreen());
    //
    //   box.write('patientId', patientCode);
    // } else
    if (userModel != null) {
      Follower? follower = userModel.subCollection<Follower>();
      follower.type = 'follower';
      follower.phoneNum = phoneNum!;
      follower.patientCode = patientCode!;
      follower.name = name!;
      await follower.create(
          docId: '${user?.docId}${follower.phoneNum}${follower.name}');
      followerId = follower.patientCode;
      update();
      _follower = follower;
      update();
      log('follower ${_follower?.toMap}');
      Get.to(() => HomeScreen());
      box.write('patientId', patientCode);

      log('FId $followerId');
    }
  }

  void enterTypeOfUser(String userT) {
    box.write('userType', userT);
    userType = userT;
    update();
  }

  void createAccountForDoctor({context, Doctor? doctor}) async {
    User? user = await AuthService().register(doctor!.email, doctor.password);
    if (user != null) {
      doctor.docId = user.uid;
      await doctor.create(docId: user.uid);
      Navigator.pushReplacementNamed(context, RoutsNames.homeScreenForDoctor);
    } else {
      log('user not found');
    }
  }

  void signIn(context, String email, String password) async {
    User? user = await AuthService().signIn(email, password);
    await getUserData();
    Navigator.pushReplacementNamed(context, RoutsNames.homeScreenForDoctor);
    Notifications.success('تم تسجيل الدخول بنجاح');
  }

  void logOutForDoctor(context) async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(
        context, RoutsNames.tapBarForRegestrationScreen,
        arguments: 2);
  }

  void createReport(
    context,
    String date,
    time,
    fasting,
    reminder,
    pills,
  ) async {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? userModel =
        await FirestoreModel.use<UserModel>().find(user!.uid);
    Report? report = userModel?.subCollection<Report>();
    report?.uId = user.uid;
    report?.date = date;
    report?.time = time;
    report?.shortAction = shortAction!;
    report?.longAction = longAction!;

    report?.fasting = fasting;
    report?.reminder = reminder;
    report?.pills = pills;

    await report?.create();
    Notifications.success('success create report');
    Navigator.pop(context);
  }

  void createSurvey({
    Survey? survey,
  }) async {
    survey = user?.subCollection<Survey>();
    survey?.create();
  }
}
