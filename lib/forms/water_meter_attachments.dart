import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/forms/water_and_electricity_information/notifier/water_and_electricity_form_notifier.dart';
import 'package:lesedi/helpers/utils.dart';

class MeterAttachments extends StatelessWidget {
  const MeterAttachments(
      {required this.applicant_id,
      required this.notifier,
      required this.title,
      required this.isLoading,
      required this.attachments,
      required this.onCameraTap,
      required this.onGalleryTap,
      super.key});

  final WaterAndElectricityFormNotifier notifier;
  final int applicant_id;
  final String title;
  final List<String> attachments;
  final bool isLoading;
  final Function() onCameraTap;
  final Function() onGalleryTap;

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
                    child: !isLoading
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
                      onCamera: onCameraTap,
                      onGallery: onGalleryTap,
                    );
                  },
                  child: !isLoading
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
//         notifier.waterMeterAttachmentsList != null
//             ? Container(
//           height: notifier.waterMeterAttachmentsList != null ? 150 : 0,
//           child: CachedNetworkImage(
//             placeholder: (context, url) => CircularProgressIndicator(),
//             imageUrl: notifier.waterMeterAttachmentsList != null
//                 ? spouse_id_storage
//                 : 'http://via.placeholder.com/1x1',
// //            height: 150,
//             errorWidget: (context, url, error) => Icon(Icons.error),
//           ),
//         )
//             :
        attachments.isNotEmpty
            ? Container(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                alignment: Alignment.center,
                height: 150,
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(attachments.length, (index) {
                      return Center(
                        child: Image.file(
                          File(attachments[index]),
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    })),
              )
            : SizedBox(),
      ],
    );
  }
}
