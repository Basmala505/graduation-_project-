import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:easysugar/help/routs/routs_name.dart';
import 'package:easysugar/model/perdictions.dart';
import 'package:easysugar/model/users.dart';
import 'package:easysugar/view_model/auth/auth.service.dart';
import 'package:easysugar/view_model/auth/auth_veiw_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  late AuthService? authService;

  AuthBloc({this.authService}) : super(AuthState(user: UserModel()));

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserModel? userModel =
          await FirestoreModel.use<UserModel>().find(user.uid);
      //log("uid ${userModel.uId}");
      emit(state.copyWith(user: userModel));
      log("userF ${user}");
      log("userModel ${state.user?.toMap}");

      log("stateUserId ${state.user?.docId}");
    }
  }

  userModel() async {
    String? id = FirebaseAuth.instance.currentUser?.uid;
    UserModel? userModel = await FirestoreModel.use<UserModel>().find(id!);
    return userModel!;
  }

  void logOut(context) async {
    await AuthService().logout();
    Navigator.pushReplacementNamed(
        context, RoutsNames.tapBarForRegestrationScreen,
        arguments: 1);
  }

  void createAccount({context, UserModel? userModel}) async {
    User? user =
        await AuthService().register(userModel!.email, userModel.password);
    if (user != null) {
      userModel.docId = user.uid;
      await userModel.create(docId: user.uid);
      Navigator.pushReplacementNamed(context, RoutsNames.homeScreenForPatient);
    } else {
      log('user not found');
    }
  }

  void signIn(context, String email, String password) async {
    User? user = await AuthService().signIn(email, password);
    if (user != null) {
      await getUserData();
      Navigator.pushReplacementNamed(context, RoutsNames.homeScreenForPatient);
      // Notifications.success('???? ?????????? ???????????? ??????????');
      // Modular.to.pushReplacementNamed(AppRoutes.mainHome);
    }
    // log('provider: ${user.providerData.single.providerId}');}
    // if (user.emailVerified == true) {
    //   log(user.emailVerified);
    //   log('finish verify email');
    //   Notifications.success('???? ?????????? ???????????? ??????????');
    //   Modular.to.pushReplacementNamed(AppRoutes.mainHome);
    // }
    else {
      /*await _authService.logout();
        log(user.emailVerified);
        Notifications.dialog(
          context,
          dismissible: true,
          child: Dialog(
            child: Container(
              // height: 120,
              child: const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  'You must verify your email',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        );*/
      log('loading verify email');
    }
  }

  void signInWithGoogle({context, String? page}) async {
    UserCredential? user = await AuthService().signInWithGoogle();
    log(user.user!.email.toString());

    if (user.user != null) {
      UserModel userModel = UserModel.fromAuth(user.user!);
      if (!await userModel.exists(user.user!.uid)) {
        await userModel.create(docId: user.user!.uid);
      }
      log('provider: ${user.user!.providerData.single.providerId}');
      await getUserData();
      Navigator.pushReplacementNamed(context, page!);

      // Modular.to.pushReplacementNamed(AppRoutes.mainHome);

    } else {}
  }

  void signInWithFacebook() async {
    UserCredential user = await AuthService().signInWithFaceBook();
    log('email${user.user?.email!}');
    log('phoneNumber${user.user?.phoneNumber}');
    log('displayName${user.user?.displayName}');

    if (user.user != null) {
      UserModel userModel = UserModel.fromAuth(user.user!);
      if (!await userModel.exists(userModel.docId!)) {
        await userModel.create(docId: userModel.docId!);
      }
      log('provider: ${user.user?.providerData.single.providerId}');
      await getUserData();
      // Modular.to.pushReplacementNamed(AppRoutes.mainHome);
    }
  }

  void createPrediction(String date, time, gluco, activityType, duration, meal,
      cal, carbs) async {
    User? user = FirebaseAuth.instance.currentUser;
    UserModel? userModel =
        await FirestoreModel.use<UserModel>().find(user!.uid);
    Prediction? prediction = userModel?.subCollection<Prediction>();
    prediction?.date = date;
    prediction?.shortAction = Get.put(AuthVeiwModel()).shortAction!;
    prediction?.longAction = Get.put(AuthVeiwModel()).longAction!;
    prediction?.time = time;
    prediction?.glucose = gluco;
    prediction?.lunch = meal;
    prediction?.activityType = activityType;
    prediction?.duration = duration;
    prediction?.cal = cal;
    prediction?.carbs = cal;
    await prediction?.create();
  }
}
