import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/forms/water_and_electricity_information/notifier/water_and_electricity_form_notifier.dart';
import 'package:lesedi/forms/water_and_electricity_information/widget/water_meter_attachments.dart';
import 'package:lesedi/widgets/common_widgets/coordinate_widget.dart';

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
    final notifier = ref.watch(waterAndElectricityFormProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
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
              child: Column(
                children: [
                  FormFieldWidget(
                    controller: notifier.waterMeterNumberController,
                    label: "Water Meter Number",
                  ),
                  FormFieldWidget(
                    controller: notifier.waterMeterReadingController,
                    label: "Water Meter Readings",
                  ),
                  FormFieldWidget(
                    controller: notifier.electricityMeterNumberController,
                    label: "Electricity Meter Number",
                  ),
                  FormFieldWidget(
                    controller: notifier.electricityMeterReadingsController,
                    label: "Electricity Meter Readings",
                  ),
                  MeterAttachments(
                    title: "Water Meter Attachments",
                    notifier: notifier,
                    applicant_id: applicant_id,
                    attachments: notifier.waterMeterAttachmentsList,
                    isLoading: notifier.isWaterAttachments,
                    onCameraTap: () {
                      notifier.getWaterAttachments(
                          context: context,
                          applicant_id: applicant_id,
                          image_name: "water_meter_attachment");
                      Navigator.pop(context);
                    },
                    onGalleryTap: () {
                      notifier.getWaterAttachments(
                          context: context,
                          isCamera: false,
                          applicant_id: applicant_id,
                          image_name: "water_meter_attachment");
                      Navigator.pop(context);
                    },
                  ),
                  MeterAttachments(
                    title: "Electricity Meter Attachments",
                    notifier: notifier,
                    applicant_id: applicant_id,
                    attachments: notifier.electricMeterAttachmentsList,
                    isLoading: notifier.isElectricityAttachments,
                    onCameraTap: () {
                      notifier.getElectricAttachments(
                          context: context,
                          applicant_id: applicant_id,
                          image_name: "electricity_meter_attachment");
                      Navigator.pop(context);
                    },
                    onGalleryTap: () {
                      notifier.getElectricAttachments(
                          context: context,
                          isCamera: false,
                          applicant_id: applicant_id,
                          image_name: "electricity_meter_attachment");
                      Navigator.pop(context);
                    },
                  ),
                  MeterAttachments(
                    title: "Property Attachments",
                    notifier: notifier,
                    applicant_id: applicant_id,
                    attachments: notifier.propertyAttachmentsList,
                    isLoading: notifier.isPropertyAttachments,
                    onCameraTap: () {
                      notifier.getPropertyAttachments(
                          context: context,
                          applicant_id: applicant_id,
                          image_name: "property_attachment");
                      Navigator.pop(context);
                    },
                    onGalleryTap: () {
                      notifier.getPropertyAttachments(
                          context: context,
                          isCamera: false,
                          applicant_id: applicant_id,
                          image_name: "property_attachment");
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
              child: notifier.lat.isNotEmpty && notifier.lng.isNotEmpty
                  ? CoordinateWidget(
                lat: notifier.lat,
                lng: notifier.lng,
              )
                  : CircularProgressIndicator(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: InkWell(
                onTap: () async {
                  await notifier.submitForm(
                      context: context,
                      applicantId: applicant_id,
                      previousFormSubmitted: previousFormSubmitted);
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(-4, 0),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: notifier.isFormLoading
                            ? Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        )
                            : Icon(
                          Icons.arrow_forward_ios,
                          size: 30,
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
            ),
          ],
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

showAlertDialog(
    {required BuildContext context,
    required String userRole,
    required int applicantID}) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop(false);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Okay"),
    onPressed: () {
//        Navigator.of(context).pop(true);
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) => Dashboard(userRole: userRole, applicant_id: applicantID)));
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
