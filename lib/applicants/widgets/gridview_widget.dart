import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lesedi/applicantDetails/details/view/details.dart';
import 'package:lesedi/applicantDetails/details/view/localDetails.dart';
import 'package:lesedi/applicants/norifier/all_applicants_notifier.dart';
import 'package:lesedi/common_services/local_storage.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/utils/constants.dart';

Widget gridViewWidget({required List<Map<String, dynamic>> mapData,required AllApplicantsNotifier notifier}) {
  return ListView(
    children: [
      ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          itemCount: mapData.length,
          itemBuilder: (context, position) {

            return Dismissible(
              direction: DismissDirection.endToStart,
              key: Key(position.toString()),
              background: Container(
                color: Colors.red,
                child: Align(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      Text(
                        " Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
              onDismissed: (direction) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Application Deleted')));
              },
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Are you sure you want to delete application of ${mapData[position]['surname']}?"),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                // TODO: Delete the item from DB etc..
                                // setState(() {
                                  MyConstants.myConst.currentApplicantId =
                                  mapData[position]['id_number'];
                                  LocalStorage.localStorage
                                      .clearCurrentApplication();
                                  mapData.removeAt(position);
                                // });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                  return res;
                } else {
                  // TODO: Navigate to edit page;
                }
              },
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => LocalDetails(
                        map: mapData[position],
                        key: null,
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xffF4F4F9)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
//                          borderRadius: BorderRadius.only(Rad),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(
                                width: 7,
                                color: Colors.amber.shade800,
                              )),
                        ),
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 5),
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.58,
//                                       width: 300,
                                          child: Text(
                                            mapData[position]['first_name'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                                letterSpacing: 0.0,
                                                color: Color(0xff141414),
                                                fontFamily: "Open Sans",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        Text(
                                          mapData[position]['id_number']??"",
                                          style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14.0,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

//

                                /// Set Animation image to detailProduk layout
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
      notifier.isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
//          reverse: true,
          itemCount: notifier.models.length,
//          gridDelegate:
//              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
          itemBuilder: (context, position) {
//            MediaQueryData mediaQueryData = MediaQuery.of(context);

            return InkWell(
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ApplicantDetails(
                        id:   notifier.models[position].extremo1 ?? 0)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  key: ValueKey(notifier.models[position].extremo1),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                        onPressed: (context) {
                          print("pressed");
                          notifier.reviewedApplicant(
                              notifier.models[position].extremo1 ?? 0);
                        },
                      ),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.clear,
                        onPressed: (context) {
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
                              notifier.removeReviewedApplicant(
                                  notifier.models[position].extremo1??0);
                              print(notifier.models[position].extremo1);
                              Navigator.of(context).pop(true);
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Confirmation"),
                            content: Text(
                                "Are you sure you want to  Reject the Application?"),
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

                        },
                      ),
                    ],
                  ),
                  // actionPane: SlidableDrawerActionPane(),
//                         secondaryActions: <Widget>[
//                           IconSlideAction(
//                             color: Colors.green,
//                             icon: Icons.check,
//                             onTap: () {
//                               reviewedApplicant(models[position].extremo1);
//                             },
//                           ),
//                           IconSlideAction(
//
// //                  caption: 'Delete',
//                               color: Colors.red,
//                               icon: Icons.clear,
//                               onTap: () {
// //
//
//                                 // set up the buttons
//                                 Widget cancelButton = TextButton (
//                                   child: Text("Cancel"),
//                                   onPressed: () {
//                                     Navigator.of(context).pop(false);
//                                   },
//                                 );
//                                 Widget continueButton = TextButton (
//                                   child: Text("Okay"),
//                                   onPressed: () {
//                                     removeReviewedApplicant(
//                                         models[position].extremo1);
//                                     print(models[position].extremo1);
//                                     Navigator.of(context).pop(true);
//                                   },
//                                 );
//
//                                 // set up the AlertDialog
//                                 AlertDialog alert = AlertDialog(
//                                   title: Text("Confirmation"),
//                                   content: Text(
//                                       "Are you sure you want to  Reject the Application?"),
//                                   actions: [
//                                     cancelButton,
//                                     continueButton,
//                                   ],
//                                 );
//
//                                 // show the dialog
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return alert;
//                                   },
//                                 );
//                               }),
//                         ],
//                         dismissal: SlidableDismissal(
//                           child: SlidableDrawerDismissal(),
//                         ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xffF4F4F9)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
//                          borderRadius: BorderRadius.only(Rad),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        margin: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(
                                width: 7,
                                color: AppColors.PRIMARY_COLOR,
                              )),
                        ),
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                          EdgeInsets.only(top: 5),
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.58,
//                                       width: 300,
                                          child: Text(
                                            notifier.models[position].extremo3 ??
                                                "",
//                                                 child: Text(
                                            // models[position].extremo3 !=
                                            //         null
                                            //     ? models[position]
                                            //         .extremo3
                                            //     : '',
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                                letterSpacing: 0.0,
                                                color: Color(0xff141414),
                                                fontFamily: "Open Sans",
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 15.0),
                                          ),
                                        ),
                                        // Text(
                                        //   models[position].extremo2 !=
                                        //           null
                                        //       ? models[position].extremo2
                                        //       : '',
                                        Text(
                                          notifier.models[position].extremo2 ?? "",
                                          style: TextStyle(
                                            fontFamily: "sans",
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14.0,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

//

                                /// Set Animation image to detailProduk layout
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          })
    ],
  );
}