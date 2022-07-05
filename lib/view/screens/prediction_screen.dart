import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:easysugar/help/my_colors_app.dart';
import 'package:easysugar/help/notifications.dart';
import 'package:easysugar/help/routs/routs_name.dart';
import 'package:easysugar/model/users.dart';
import 'package:easysugar/view/custom_widet/custom_drawer.dart';
import 'package:easysugar/view/custom_widet/custom_drob_down_menu.dart';
import 'package:easysugar/view/custom_widet/custom_drob_menue_long_action.dart';
import 'package:easysugar/view/custom_widet/custom_text.dart';
import 'package:easysugar/view/custom_widet/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom_widet/custom_add_prediction.dart';

// ignore: must_be_immutable
class PredictionScreen extends StatefulWidget {
  PredictionScreen({Key? key}) : super(key: key);

// test
  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String selectedItemTypeOfFood = "launch";
  List<String> typeOfFoodList = ["launch", "dinner", "breakfast"];
  var calController = TextEditingController();

  var activityController = TextEditingController();
  var weightController = TextEditingController();
  var glucoseController = TextEditingController();
  var carbsController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  key: scaffoldKey,
      appBar: AppBar(
          backgroundColor: ColorsApp.primaryColor,
          title: const CustomText(
            text: "Prediction",
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, RoutsNames.homeScreenForPatient);
                },
                icon: const Icon(Icons.home))
          ]),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              CustomAddPrediction(
                readOnly: false,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.parse('2030-10-03'),
                  ).then((value) {
                    dateController.text = DateFormat.yMMMd().format(value!);
                  });
                  log("object");
                },
                labelText: "Date",
                controller: dateController,
                assetsImage: "assets/images/icons8-date-64.png",
                // color: ColorsApp.primaryColor,
              ),
              CustomAddPrediction(
                  readOnly: false,
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then(
                      (value) {
                        timeController.text =
                            value!.format(context).split('/').first.toString();
                      },
                    );
                  },
                  labelText: "Time",
                  controller: timeController,
                  assetsImage: "assets/images/icons8-music-time-100.png"),
              CustomAddPrediction(
                onTap: () {},
                controller: glucoseController,
                assetsImage: "assets/images/icons8-insulin-pen-48.png",
                labelText: "Glucose measurement",
              ),
              CustomAddPrediction(
                onTap: () {},
                controller: activityController,
                assetsImage: "assets/images/icons8-activity-64.png",
                labelText: "Activity type",
              ),
              Column(
                children: [
                  const CustomText(
                    fontWeight: FontWeight.bold,
                    text: "Weight",
                    color: ColorsApp.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    color: Colors.white12,
                    controller: weightController,
                    lableText: "weight ?",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const CustomText(
                    fontWeight: FontWeight.bold,
                    text: " Choose your meal",
                    color: ColorsApp.primaryColor,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorsApp.primaryColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedItemTypeOfFood,
                      items: typeOfFoodList.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedItemTypeOfFood = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const CustomText(
                    fontWeight: FontWeight.bold,
                    text: " cal",
                    color: ColorsApp.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    color: Colors.white12,
                    controller: calController,
                    lableText: "cal ?",
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const CustomText(
                    fontWeight: FontWeight.bold,
                    text: " Carbs",
                    color: ColorsApp.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    color: Colors.white12,
                    controller: carbsController,
                    lableText: "carbs ?",
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Column(
                children: const [
                  CustomText(
                    text: "Short Action",
                    color: ColorsApp.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDropDownMenuShortAction(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: const [
                  CustomText(
                      text: "Long Action",
                      color: ColorsApp.primaryColor,
                      fontWeight: FontWeight.bold),
                  SizedBox(
                    height: 10,
                  ),
                  CustomDrobDownMenuLongAction(),
                ],
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsApp.primaryColor,
        onPressed: () {
          validationInput();
        },
        child: const Icon(
          Icons.add,
        ),
      ),

      drawer: const CustomDrawer(),
    );
  }

  validationInput() {
    if (dateController.text.isEmpty) {
      Notifications.error('You must enter date');
    } else if (timeController.text.isEmpty) {
      Notifications.error('You must enter time');
    } else if (glucoseController.text.isEmpty) {
      Notifications.error('You must enter glucose');
    } else if (activityController.text.isEmpty) {
      Notifications.error('You must enter activity type');
    } else if (weightController.text.isEmpty) {
      Notifications.error('You must enter duration');
    } else if (selectedItemTypeOfFood.isEmpty) {
      Notifications.error('You must enter food type');
    } else if (calController.text.isEmpty) {
      Notifications.error('You must enter cal');
    } else if (carbsController.text.isEmpty) {
      Notifications.error('You must enter carb');
    } else {
      UserModel userModel = UserModel(
        date: dateController.text,
        time: timeController.text,
        lunch: selectedItemTypeOfFood,
        activityType: activityController.text,
        duration: weightController.text,
        glucose: glucoseController.text,
      );
      userModel.update(
        data: {
          "time": timeController.text,
          "date": dateController.text,
          "activityType": activityController.text,
          "duration": weightController.text,
          "glucose": glucoseController.text,
          // "longAction": longAction,
          "lunch": selectedItemTypeOfFood,
          "cal": calController.text,
          "carbs": carbsController.text,
          // "shortAction": shortAction,
        },
        docId: FirebaseAuth.instance.currentUser?.uid,
      ).then((value) {
        Notifications.success('success create prediction');
      }).then(
        (value) {
          int weight = int.parse(weightController.text);
          // Carbohydrates
          int carbs = int.parse(carbsController.text);
          // Blood glucose
          int bg = int.parse(glucoseController.text);
          const int TBG = 120;
          var TDI = 0.55 * weight;
          var itCarbRatio = 500 / TDI;
          var cFactor = 1800 / TDI;
          var x = carbs / itCarbRatio;
          var y = (bg - TBG) / cFactor;
          var totalDose = x + y;

          log('total dose = $totalDose');
          showDialog(
            context: context,
            builder: (BuildContext context) => Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your weight : $weight',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your glucose : $bg',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your Dose should be : ${totalDose.toInt()}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -30,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -30,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutsNames.homeScreenForPatient,
                          );
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          child: const Icon(
                            Icons.keyboard_return,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
