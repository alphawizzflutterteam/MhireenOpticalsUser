import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EyePrescriptionForm extends StatefulWidget {
  @override
  _EyePrescriptionFormState createState() => _EyePrescriptionFormState();
}

class _EyePrescriptionFormState extends State<EyePrescriptionForm> {
  // Right side controllers
  final TextEditingController rightSphController = TextEditingController();
  final TextEditingController rightCylController = TextEditingController();
  final TextEditingController rightAxisController = TextEditingController();
  final TextEditingController rightDController = TextEditingController();
  final TextEditingController rightNController = TextEditingController();
  final TextEditingController rightAddController = TextEditingController();

  // Left side controllers
  final TextEditingController leftSphController = TextEditingController();
  final TextEditingController leftCylController = TextEditingController();
  final TextEditingController leftAxisController = TextEditingController();
  final TextEditingController leftDController = TextEditingController();
  final TextEditingController leftNController = TextEditingController();
  final TextEditingController leftAddController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    rightSphController.dispose();
    rightCylController.dispose();
    rightAxisController.dispose();
    rightDController.dispose();
    rightNController.dispose();
    rightAddController.dispose();

    leftSphController.dispose();
    leftCylController.dispose();
    leftAxisController.dispose();
    leftDController.dispose();
    leftNController.dispose();
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
                  Icon(
                    Icons.remove_red_eye,
                    size: 35,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
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
            _buildEyeSection(
                'Right Eye',
                rightSphController,
                rightCylController,
                rightAxisController,
                rightDController,
                rightNController,
                rightAddController),
            SizedBox(height: 20),
            _buildEyeSection(
                'Left Eye',
                leftSphController,
                leftCylController,
                leftAxisController,
                leftDController,
                leftNController,
                leftAddController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle save or submission of data
                print('Right Side SPH: ${rightSphController.text}');
                print('Left Side SPH: ${leftSphController.text}');
                // Add more print statements for other fields as needed
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeSection(
      String title,
      TextEditingController sphController,
      TextEditingController cylController,
      TextEditingController axisController,
      TextEditingController dController,
      TextEditingController nController,
      TextEditingController addController) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
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
            _buildEyeRow(sphController, cylController, axisController),
            // SizedBox(height: 10),
            // _buildEyeRow(dController, nController, addController),
          ],
        ),
      ),
    );
  }

  Widget _buildEyeRow(TextEditingController controller1,
      TextEditingController controller2, TextEditingController controller3) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSideBar(),
        _buildTextField('SPH', controller1, false),
        _buildTextField('CYL', controller2, true),
        _buildTextField('AXIS', controller3, true),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isHide) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          Text(label),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextFormField(
              readOnly: isHide,
              controller:
                  isHide == true ? TextEditingController(text: '') : controller,
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
}
