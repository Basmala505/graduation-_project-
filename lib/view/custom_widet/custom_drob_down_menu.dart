import 'dart:developer';

import 'package:easysugar/view_model/auth/auth_veiw_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../help/constant.dart';
import '../../help/my_colors_app.dart';

class CustomDropDownMenuShortAction extends StatefulWidget {
  const CustomDropDownMenuShortAction({Key? key}) : super(key: key);

  @override
  State<CustomDropDownMenuShortAction> createState() =>
      _CustomDropDownMenuShortActionState();
}

class _CustomDropDownMenuShortActionState
    extends State<CustomDropDownMenuShortAction> {
  String selectedItemShortAction = "Actrapid";
  var auth = Get.put(AuthVeiwModel());
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width ,
      // width: w,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsApp.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton(
            value: auth.shortAction ?? selectedItemShortAction,
            items: shortActionList.map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                auth.shortAction = value!;
                log('sh ${auth.shortAction}');
                // UserModel userModel = UserModel();
                // userModel.update(
                //     docId: FirebaseAuth.instance.currentUser?.uid,
                //     data: {
                //       "shortAction": selectedItemShortAction,
                //     });
              });
            },
          ),
        ],
      ),
    );
  }
}
