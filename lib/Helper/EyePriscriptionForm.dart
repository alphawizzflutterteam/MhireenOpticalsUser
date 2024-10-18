import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mahireenopticals/Helper/Color.dart';
import 'package:selector_wheel/selector_wheel/models/selector_wheel_value.dart';
import 'package:selector_wheel/selector_wheel/selector_wheel.dart';

class EyePrescriptionForm extends StatefulWidget {
  @override
  _EyePrescriptionFormState createState() => _EyePrescriptionFormState();
}

class _EyePrescriptionFormState extends State<EyePrescriptionForm> {
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(10),
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
                          color: colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black)),
                      child: Text("  EYE PRESCRIPTION",
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
            ElevatedButton(
              onPressed: () {},
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeSection({required String title, required bool isLeft}) {
    return Container(
      decoration: BoxDecoration(
          color: colors.white10,
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

    String value1 = '';
    String value2 = '';
    String value3 = '';

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
                onValueSelected(
                    value1 == "Plano" ? "Plano" : value1 + value2 + value3);
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
