import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:mahireenopticals/Helper/Session.dart';
import 'package:mahireenopticals/Helper/String.dart';
import 'package:selector_wheel/selector_wheel/models/selector_wheel_value.dart';
import 'package:selector_wheel/selector_wheel/selector_wheel.dart';

class EyePrescriptionForm extends StatefulWidget {
  final List<String> productlist;

  const EyePrescriptionForm({super.key, required this.productlist});
  @override
  _EyePrescriptionFormState createState() => _EyePrescriptionFormState();
}

class _EyePrescriptionFormState extends State<EyePrescriptionForm> {
  // Right side controllers
  final TextEditingController rightSphDistanceController =
      TextEditingController();
  final TextEditingController rightCylDistanceController =
      TextEditingController();
  final TextEditingController rightAxisDistanceController =
      TextEditingController();
  final TextEditingController rightSphNearController = TextEditingController();
  final TextEditingController rightCylNearController = TextEditingController();
  final TextEditingController rightAxisNearController = TextEditingController();
  final TextEditingController rightAddController = TextEditingController();

  // Left side controllers
  final TextEditingController leftSphDistanceController =
      TextEditingController();
  final TextEditingController leftCylDistanceController =
      TextEditingController();
  final TextEditingController leftAxisDistanceController =
      TextEditingController();
  final TextEditingController leftSphNearController = TextEditingController();
  final TextEditingController leftCylNearController = TextEditingController();
  final TextEditingController leftAxisNearController = TextEditingController();
  final TextEditingController leftAddController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    rightSphDistanceController.dispose();
    rightCylDistanceController.dispose();
    rightAxisDistanceController.dispose();
    rightSphNearController.dispose();
    rightCylNearController.dispose();
    rightAxisNearController.dispose();
    rightAddController.dispose();
    leftSphDistanceController.dispose();
    leftCylDistanceController.dispose();
    leftAxisDistanceController.dispose();
    leftSphNearController.dispose();
    leftCylNearController.dispose();
    leftAxisNearController.dispose();
    leftAddController.dispose();
    leftAddController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  // padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      // Icon(
                      //   Icons.remove_red_eye,
                      //   size: 35,
                      //   color: Colors.black,
                      // ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black)),
                          child: Text("EYE PRESCRIPTION",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22)),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildEyeSection(title: 'Right Eye', isLeft: false),
                SizedBox(height: 20),
                _buildEyeSection(title: 'Left Eye', isLeft: true),
                SizedBox(height: 20),
                isLoading == true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (rightSphDistanceController.text != '' &&
                              leftSphDistanceController.text != '' &&
                              rightCylDistanceController.text != '' &&
                              leftCylDistanceController.text != '' &&
                              rightAxisDistanceController.text != '' &&
                              leftAxisDistanceController.text != '' &&
                              rightSphNearController.text != '' &&
                              leftSphNearController.text != '' &&
                              rightAddController.text != '' &&
                              leftAddController.text != '') {
                            paypalPayment(buildContext: context);
                          } else {
                            setSnackbar("Please fill all the field", context);
                          }
                        },
                        child: Text('Save'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> paypalPayment({required BuildContext buildContext}) async {
    try {
      setState(() {
        isLoading = true;
      });
      String productId = '';
      String varientId = '';

      for (var i = 0; i < widget.productlist.length; i++) {
        productId =
            i == 0 ? widget.productlist[i] : ',' + widget.productlist[i];
      }
      var parameter = {
        USER_ID: CUR_USERID,
        "right_d_sph": rightSphDistanceController.text,
        "left_d_sph": leftSphDistanceController.text,
        "right_d_cyl": rightCylDistanceController.text,
        "left_d_cyl": leftCylDistanceController.text,
        "right_d_axis": rightAxisDistanceController.text,
        "left_d_axis": leftAxisDistanceController.text,
        "right_n_sph": rightSphNearController.text,
        "left_n_sph": leftSphNearController.text,
        "right_add_sph": rightAddController.text,
        "left_add_sph": leftAddController.text,
        "product_id": productId,
        "product_variant_id": varientId
      };
      print("anjali eye____${parameter}");
      Response response = await post(
              Uri.parse(
                  "https://mahireenopticals.in/app/v1/api/add_eye_prescription"),
              body: parameter,
              headers: headers)
          .timeout(Duration(seconds: 30));
      var getdata = json.decode(response.body);
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        Navigator.pop(buildContext, true);
      } else {
        setSnackbar(msg!, buildContext);
        Navigator.pop(buildContext, false);
      }

      setState(() {
        isLoading = false;
      });
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(buildContext, 'somethingMSg')!, buildContext);
      setState(() {
        isLoading = false;
      });
      Navigator.pop(buildContext, false);
    }
  }

  Widget _buildEyeSection({required String title, required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.remove_red_eye,
                  size: 20,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            SizedBox(height: 10),
            _buildEyeRow(isLeft: isLeft),
            // SizedBox(height: 10),
            // _buildEyeRow(dController, nController, addController),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeRow({required isLeft}) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSideBar(),
        _buildTextField(
            label: 'SPH',
            DController:
                isLeft ? leftSphDistanceController : rightSphDistanceController,
            AddController: isLeft ? leftAddController : rightAddController,
            NController:
                isLeft ? leftSphNearController : rightSphNearController,
            isHide: false),
        _buildTextField(
            label: 'CYL',
            DController:
                isLeft ? leftCylDistanceController : rightCylDistanceController,
            AddController: isLeft ? leftAddController : rightAddController,
            NController:
                isLeft ? leftSphNearController : rightCylNearController,
            isHide: true),
        _buildTextField(
            label: 'AXIS',
            DController: isLeft
                ? leftAxisDistanceController
                : rightAxisDistanceController,
            AddController: isLeft ? leftAddController : rightAddController,
            NController:
                isLeft ? leftAxisNearController : rightAxisNearController,
            isHide: true),
      ],
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController DController,
      required TextEditingController NController,
      required TextEditingController AddController,
      required bool isHide}) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(label),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              onTap: label == "AXIS"
                  ? null
                  : () {
                      _showValueSelectorDialog(
                        label: label,
                        isNear: false,
                        context: context,
                        currentValue: DController.text,
                        onValueSelected: (p0) {
                          // if (label == 'SPH') {

                          // }else if(label == 'CYL'){

                          // }else{

                          // }

                          DController.text = p0.toString();

                          if (label == 'SPH') {
                            if (DController.text != '' &&
                                NController.text == '') {
                              AddController.text = DController.text;
                            } else if (DController.text == '' &&
                                NController.text != '') {
                              AddController.text = NController.text;
                            } else if ((DController.text == 'Plano' ||
                                    DController.text == '') &&
                                (NController.text == 'Plano' ||
                                    NController.text == '')) {
                              AddController.text = 'Plano';
                            } else if (DController.text == '' &&
                                NController.text == '') {
                              AddController.text = '';
                            } else {
                              double a =
                                  double.tryParse(DController.text) ?? 0.0;
                              double b =
                                  double.tryParse(NController.text) ?? 0.0;
                              double total = a + b;
                              AddController.text = total.toString();

                              if ((DController.text.contains("+") &&
                                      NController.text.contains("-")) ||
                                  (DController.text.contains("-") &&
                                      NController.text.contains("+"))) {
                                AddController.text = '-' + AddController.text;
                              } else if (DController.text.contains("+") &&
                                  NController.text.contains("+")) {
                                AddController.text = '+' + AddController.text;
                              } else if (DController.text.contains("-") &&
                                  NController.text.contains("-")) {
                                AddController.text = '-' + AddController.text;
                              }
                            }
                          }
                        },
                      );
                    },
              readOnly: label == "AXIS" ? false : true,
              controller: DController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              onTap: isHide == true
                  ? null
                  : () {
                      _showValueSelectorDialog(
                        label: label,
                        isNear: true,
                        context: context,
                        currentValue: DController.text,
                        onValueSelected: (p0) {
                          NController.text = p0.toString();

                          if (label == 'SPH') {
                            if (DController.text != '' &&
                                NController.text == '') {
                              AddController.text = DController.text;
                            } else if (DController.text == '' &&
                                NController.text != '') {
                              AddController.text = NController.text;
                            } else if ((DController.text == 'Plano' ||
                                    DController.text == '') &&
                                (NController.text == 'Plano' ||
                                    NController.text == '')) {
                              AddController.text = 'Plano';
                            } else if (DController.text == '' &&
                                NController.text == '') {
                              AddController.text = '';
                            } else {
                              double a =
                                  double.tryParse(DController.text) ?? 0.0;
                              double b =
                                  double.tryParse(NController.text) ?? 0.0;
                              double total = a + b;
                              AddController.text = total.toString();

                              if ((DController.text.contains("+") &&
                                      NController.text.contains("-")) ||
                                  (DController.text.contains("-") &&
                                      NController.text.contains("+"))) {
                                AddController.text = '-' + AddController.text;
                              } else if (DController.text.contains("+") &&
                                  NController.text.contains("+")) {
                                AddController.text = '+' + AddController.text;
                              } else if (DController.text.contains("-") &&
                                  NController.text.contains("-")) {
                                AddController.text = '-' + AddController.text;
                              }
                            }
                          }
                        },
                      );
                    },
              readOnly: true,
              controller: isHide == true
                  ? TextEditingController(text: '')
                  : NController,
              decoration: InputDecoration(
                border:
                    isHide == true ? InputBorder.none : UnderlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              readOnly: true,
              controller: isHide == true
                  ? TextEditingController(text: '')
                  : AddController,
              decoration: InputDecoration(
                border:
                    isHide == true ? InputBorder.none : UnderlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideBar() {
    return Expanded(
      flex: 2,
      child: Container(
        child: Column(
          children: [
            Text("   "),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: 'Distance'),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: 'Near    '),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              readOnly: true,
              controller: TextEditingController(text: 'Add     '),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 12),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  void _showValueSelectorDialog(
      {required BuildContext context,
      required String currentValue,
      required Function(String) onValueSelected,
      required bool isNear,
      required String label}) {
    double tempValue =
        currentValue == "Plano" ? 0.00 : double.tryParse(currentValue) ?? 0.00;
    List list1 = isNear ? ['plano', '+'] : ['plano', '+', '-'];
    List list2 = [0.00, 0.25, 0.50, 0.75];

    String value1 = 'Plano';
    String value2 = '0';
    String value3 = '0.00';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Value"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Swipe Up/Down to change value'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 100,
                    child: SelectorWheel(
                      childCount: isNear ? 2 : 3,
                      enableFadeOut: false,
                      convertIndexToValue: (int index) {
                        return SelectorWheelValue(
                          label: list1[index].toString(),
                          value: list1[index],
                          index: index,
                        );
                      },
                      onValueChanged: (SelectorWheelValue value) {
                        // print the value that was selected
                        value1 = value.label;
                      },
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 100,
                    child: SelectorWheel(
                      childCount: label == 'CYL' ? 13 : 25,
                      enableFadeOut: false,
                      convertIndexToValue: (int index) {
                        return SelectorWheelValue(
                          label: index.toString(),
                          value: index,
                          index: index,
                        );
                      },
                      onValueChanged: (SelectorWheelValue<int> value) {
                        // print the value that was selected
                        value2 = value.label;
                      },
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 100,
                    child: SelectorWheel(
                      childCount: 4,
                      enableFadeOut: false,
                      convertIndexToValue: (int index) {
                        return SelectorWheelValue(
                          label: list2[index].toString(),
                          value: list2[index],
                          index: index,
                        );
                      },
                      onValueChanged: (SelectorWheelValue value) {
                        // print the value that was selected
                        value3 = value.label;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('CLEAR'),
            ),
            TextButton(
              onPressed: () {
                onValueSelected(value1 == "Plano"
                    ? "Plano"
                    : value1 + value2 + '.' + value3.split('.')[1]);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
