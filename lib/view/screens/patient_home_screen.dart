import 'dart:developer';

import 'package:easysugar/help/constant.dart';
import 'package:easysugar/help/routs/routs_name.dart';
import 'package:easysugar/model/users.dart';
import 'package:easysugar/view/custom_widet/custom_curve.dart';
import 'package:easysugar/view/custom_widet/custom_drawer.dart';
import 'package:easysugar/view/custom_widet/custom_text.dart';
import 'package:easysugar/view_model/auth/auth_veiw_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_model/firestore_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../custom_widet/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthVeiwModel authVeiwModel = Get.put(AuthVeiwModel());

  @override
  void initState() {
    log('init');
    authVeiwModel.getUserData();
    log('end');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(authVeiwModel.user.toString());
    return ModelStreamSingleBuilder<UserModel>(
        // parentModel: authVeiwModel.user,
        docId: FirebaseAuth.instance.currentUser?.uid ?? box.read('patientId'),
        onError: (e) => const Text('error'),
        onEmpty: () => const Text('no result'),
        onSuccess: (user) {
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: const Color(0xff08877A),
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Color(0xff08877A),
                ),
                title: const CustomText(
                  text: "Welcome To Easy Sugar",
                  fontSise: 22,
                  fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
              ),
              body: Stack(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CustomBackground(),
                      customContainer(
                        context,
                        child: user?.date != ''
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const CustomText(
                                        text: "B G",
                                        color: Colors.black,
                                        fontSise: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                          height: 30,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/icons8-glucose-meter-64.png"),
                                            fit: BoxFit.fill,
                                          )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CustomText(
                                        text: user?.glucose,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CustomText(
                                        text: "Insulin",
                                        color: Colors.black,
                                        fontSise: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                          height: 30,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/icons8-insulin-pen-48.png"),
                                            fit: BoxFit.fill,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: user?.shortAction,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            text: user?.shortAction,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CustomText(
                                        text: "Food ",
                                        color: Colors.black,
                                        fontSise: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                          height: 30,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/icons8-broccoli-16.png"),
                                            fit: BoxFit.fill,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: user?.lunch,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            height: .9,
                                          ),
                                          CustomText(
                                            text: user?.carbs,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            height: .9,
                                          ),
                                          CustomText(
                                            text: user?.cal,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const CustomText(
                                        text: "Activity",
                                        color: Colors.black,
                                        fontSise: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                          height: 30,
                                          child: Image(
                                            image: AssetImage(
                                                "assets/images/icons8-running-16.png"),
                                            fit: BoxFit.fill,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            text: user?.activityType,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          CustomText(
                                            text: "${user?.duration} Kg",
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            : const Center(
                                child: Text(
                                  'No Prediction Yet !',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    ontap: () {
                                      Navigator.pushNamed(
                                          context, RoutsNames.predictionScreen);
                                      log("object");
                                    },
                                    text: "Predict the insulin unit",
                                    radiusLeftTop: 25,
                                    fontSize: 22.0,
                                    radiusButtomRight: 25,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                    ontap: () {
                                      Navigator.pushNamed(
                                          context, RoutsNames.statisticsScreen);
                                    },
                                    text: "Statistics",
                                    radiusLeftTop: 25,
                                    fontSize: 22.0,
                                    radiusButtomRight: 25,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                    ontap: () {
                                      Navigator.pushNamed(
                                          context, RoutsNames.addRecordScreen);
                                    },
                                    text: "Add record +",
                                    radiusLeftTop: 25,
                                    radiusButtomRight: 25,
                                    fontSize: 22.0,
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              drawer: const CustomDrawer());
        });
  }
}

Widget customContainer(context, {Widget? child}) => Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.17,
      color: const Color(0xffE3F4FF).withOpacity(.7),
      child: child,
    );
