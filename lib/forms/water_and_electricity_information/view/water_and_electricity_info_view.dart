import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/Dashboard.dart';
import 'package:lesedi/app_color.dart';
import 'package:lesedi/forms/water_and_electricity_information/notifier/water_and_electricity_form_notifier.dart';
import 'package:lesedi/forms/water_meter_attachments.dart';

class WaterAndElectricityView extends ConsumerWidget {
  WaterAndElectricityView(
      {required this.applicant_id,
      required this.previousFormSubmitted,
      super.key});

  final int applicant_id;
  final bool previousFormSubmitted;

  final waterAndElectricityFormProvider = ChangeNotifierProvider((ref) {
    return WaterAndElectricityFormNotifier();
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("applicant_id  ===> ${applicant_id}");
    final notifier = ref.watch(waterAndElectricityFormProvider);
    return Scaffold(
      appBar: AppBar(
//        elevation: .5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
//            Navigator.of(context).pop(false);
//             showAlertDialog(context);
          },
        ),
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'PERSONAL INFORMATION',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
       body: Container(
         alignment: Alignment.center,
         margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
         padding:
         const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(5.0),
           color: const Color(0xffffffff),
           boxShadow: [
             BoxShadow(
               color: const Color(0x29000000),
               offset: Offset(0, 3),
               blurRadius: 6,
             ),
           ],
         ),
         child: SingleChildScrollView(
           child: Column(
             children: [
               FormFieldWidget(
                 controller: notifier.waterMeterNumberController,
                 label: "Water Meter Number",
               ),
               FormFieldWidget(
                 controller: notifier.waterMeterNumberController,
                 label: "Water Meter Readings",
               ),
               FormFieldWidget(
                 controller: notifier.waterMeterNumberController,
                 label: "Electricity Meter Number",
               ),
               FormFieldWidget(
                 controller: notifier.waterMeterNumberController,
                 label: "Electricity Meter Readings",
               ),
           
               WaterMeterAttachments(
                 title: "Water Attachments",
                 notifier: notifier,
                 applicant_id: applicant_id, imageName: "water_meter_attachment",
               ),
               WaterMeterAttachments(
                 title: "Electricity Attachments",
                 notifier: notifier,
                 applicant_id: applicant_id,imageName: "electricity_meter_attachment",
               ),     WaterMeterAttachments(
                 title: "Property Attachments",
                 notifier: notifier,
                 applicant_id: applicant_id,
                 imageName: "property_attachment",
               ),
             ],
           ),
         ),
       ),
    );
  }
}

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    required this.controller,
    required this.label,
    super.key,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
      ),
      child: new TextFormField(
        controller: controller,
        obscureText: false,
        decoration: new InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: const Color(0xff626a76), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColors.PRIMARY_COLOR, width: 1.0),
            ),
            labelText: label,
            labelStyle: new TextStyle(
                color: const Color(0xff626a76), fontFamily: 'opensans'),
            focusColor: AppColors.PRIMARY_COLOR,
            alignLabelWithHint: true,
            fillColor: Colors.white,
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(4.0),
                borderSide: new BorderSide(color: Colors.blue.shade700)),
            floatingLabelBehavior: FloatingLabelBehavior.auto),
        keyboardType: TextInputType.text,
        style: new TextStyle(
            fontFamily: 'opensans',
            color: AppColors.PRIMARY_COLOR,
            fontSize: 13.0),
      ),
    );
  }
}
showAlertDialog({required BuildContext context,required String userRole,required int applicantID}) {
  // set up the buttons
  Widget cancelButton = TextButton (
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = TextButton (
    child: Text("Okay"),
    onPressed: () {
//        Navigator.of(context).pop(true);
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              Dashboard(userRole, applicantID)));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure you want to exit form?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}