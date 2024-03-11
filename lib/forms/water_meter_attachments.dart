import 'package:flutter/material.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/forms/water_and_electricity_information/notifier/water_and_electricity_form_notifier.dart';
import 'package:lesedi/helpers/utils.dart';

class WaterMeterAttachments extends StatelessWidget {
  const WaterMeterAttachments(
      {required this.applicant_id,
      required this.notifier,
      required this.title,
      required this.imageName,
      super.key});

  final WaterAndElectricityFormNotifier notifier;
  final int applicant_id;
  final String title;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, bottom: 0, top: 0),
          child: Container(
            margin: EdgeInsets.only(bottom: 15),
            height: 55.0,
//                        width: 600.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                    alignment: Alignment.centerRight,
                    child: !notifier.isWaterAttachments
                        ? Icon(
                            Icons.file_upload,
                            color: Colors.black,
                            size: 20,
                          )
                        : MyConstants.myConst.internet ?? false
                            ? Container(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                            : Icon(
                                Icons.done,
                                color: Colors.black,
                                size: 20,
                              )),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Utils.alertDialog(
                        context: context,
                        onCamera: () => notifier.getImage(
                            context: context,
                            applicant_id: applicant_id,
                            image_name: imageName),
                        onGallery: () => notifier.getImage(
                            context: context,
                            isCamera: false,
                            applicant_id: applicant_id,
                            image_name: imageName));
                  },
                  child: !notifier.isWaterAttachments
                      ? Text(
                          'Upload',
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.2,
                              fontFamily: "Open Sans",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800),
                        )
                      : Text(
                          MyConstants.myConst.internet ?? false
                              ? 'Uploading'
                              : "Saved",
                          style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.2,
                              fontFamily: "Open Sans",
                              fontSize: 18.0,
                              fontWeight: FontWeight.w800),
                        ),
                ),
              ],
            ),
            alignment: FractionalOffset.center,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 0.0)],
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFFFFFFF)])),
          ),
        ),
      ],
    );
  }
}
