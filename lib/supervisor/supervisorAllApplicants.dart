import 'dart:convert';
import 'dart:developer';

import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/applicantDetails/localDetails.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/forms/Verifications.dart';
import 'package:lesedi/applicantDetails/details/view/details.dart';
import 'package:lesedi/utils/global.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/helpers/utils.dart';
import 'package:lesedi/model/applicants.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lesedi/utils/app_color.dart';

class SuperVisorAllApplicants extends StatefulWidget {
  @override
  _SuperVisorAllApplicantsState createState() =>
      _SuperVisorAllApplicantsState();
}

class _SuperVisorAllApplicantsState extends State<SuperVisorAllApplicants> {
  @override
  void initState() {
    super.initState();
    print('supervisor data');
    getLocalData();
    getAllApplicant();
  }

  bool _isVisible = true;
  ServicesRequest request = ServicesRequest();
  bool? submitStatus;
  bool isLoading = false;
  bool isSyncLoading = false;

  List<Map<String, dynamic>> mapData = <Map<String, dynamic>>[];

  getLocalData() async {
    print("Get Local Data Called");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var localData = sharedPreferences.getStringList('applicationIds');
    log('Local Data ::::  ${localData.toString()}');
    if (localData != null) {
      setState(() {
        for (int i = 0; i < localData.length; i++) {
          var responseData = sharedPreferences.getString(localData[i]);
          if (responseData != null) {
            print("Each map saved ::: $responseData");
            mapData.add(json.decode(responseData));
          } else {
            print("${localData[i]} is null");
          }
        }
      });
    }
    print(mapData);
  }

  List<NodoPOJO> models = [];

  getAllApplicant() async {
    await request.ifInternetAvailable();
    List<NodoPOJO> responseM = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    if (MyConstants.myConst.internet ?? false) {
      setState(() {
        isLoading = true;
      });
      http.Response response = await http.get(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/all_reviewed_applications"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID ?? "",
            'Authentication': authToken ?? ""
          });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);

        List<dynamic> dataHolder = jsonResponse;
        print(jsonResponse);
        print('all length');
        print(dataHolder.length);
        for (int j = 0; j < dataHolder.length; j++) {
          var dataSort = dataHolder.toList()[j];
          NodoPOJO models = NodoPOJO.fromJson(dataSort);
          responseM.add(models);
          print(responseM[0].extremo1);
        }

        setState(() {
          print('done');
          models = responseM;
          if (models.length == 0) {
            _isVisible = !_isVisible;
          }
          isLoading = false;
        });
      } else {
        setState(() {
          jsonResponse = json.decode(response.body);
          print('data');
          showToastMessage(jsonResponse['message']
              .toString()
              .replaceAll("[\\[\\](){}]", ""));
          isLoading = false;
        });
      }
    }
  }

  reviewedApplicant(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=$id&reviewed='true'"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID ?? "",
          'Authentication': authToken ?? ""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);
      getAllApplicant();
      gridViewWidget();
    } else {
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  removeReviewedApplicant(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/application_reviewed?application_id=$id&reviewed='false'"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID ?? "",
          'Authentication': authToken ?? ""
        });

    print(response.body);

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);

      print(jsonResponse);
      showToastMessage(jsonResponse['message']);
      getAllApplicant();
      gridViewWidget();
    } else {
      setState(() {
        jsonResponse = json.decode(response.body);
        print('data');
        showToastMessage(
            jsonResponse['message'].toString().replaceAll("[\\[\\](){}]", ""));
      });
    }
  }

  Widget gridViewWidget() {
    return ListView(
      children: [
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
//          reverse: true,
            itemCount: mapData.length,
//          gridDelegate:
//              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, position) {
//            MediaQueryData mediaQueryData = MediaQuery.of(context);

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
                                  setState(() {
                                    MyConstants.myConst.currentApplicantId =
                                        mapData[position]['id_number'];
                                    LocalStorage.localStorage
                                        .clearCurrentApplication();
                                    mapData.removeAt(position);
                                  });
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
                                            mapData[position]['id_number'],
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
        isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                itemCount: models.length,
                itemBuilder: (context, position) {
                  return InkWell(
                    onTap: () {
                      print(models[position].extremo1);
                      Navigator.of(context).pushReplacement(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              Verifications(models[position].extremo1 ?? 0)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Slidable(
                        key: ValueKey(models[position].extremo1.toString()),
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: <Widget>[
                            SlidableAction(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              icon: Icons.check,
                              onPressed: (context){
                                  reviewedApplicant(
                                      models[position].extremo1 ?? 0);
                                  print(models[position].extremo1);

                              },

                            ),
                            SlidableAction(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                             icon: Icons.clear,
                              onPressed: (context){
                                reviewedApplicant(models[position].extremo1??0);
                                print(models[position].extremo1);
                              },
                            ),
                          ],
                        ),
//                         actionPane: SlidableDrawerActionPane(),
//                         secondaryActions: <Widget>[
//                           IconSlideAction(
//                             color: Colors.green,
//                             icon: Icons.check,
//                             onTap: () {
//                               reviewedApplicant(models[position].extremo1);
//                               print(models[position].extremo1);
//                             },
//                           ),
//                           IconSlideAction(
// //                  caption: 'Delete',
//                             color: Colors.red,
//                             icon: Icons.clear,
//                             onTap: () {
//                               reviewedApplicant(models[position].extremo1);
//                               print(models[position].extremo1);
//                             },
//                           ),
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
//                                                 child: Text(
// //                                                   models[position].extremo3 !=
// //                                                           null
// //                                                       ? models[position]
// //                                                           .extremo3
// //                                                       : ''
                                                child: Text(
                                                  models[position].extremo3 ??
                                                      "",
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
                                                models[position].extremo2 ?? "",
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

  @override
  Widget build(BuildContext context) {
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
              Navigator.of(context).pop();
            },
          ),
          actions: [
            MyConstants.myConst.applicationsList != null &&
                    MyConstants.myConst.applicationsList!.isEmpty
                ? SizedBox()
                : isSyncLoading
                    ? SizedBox()
                    : IconButton(
                        icon: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          if (mapData.isNotEmpty) {
                            // Utils.checkFormStatusAndSubmit();
                            submitStatus = await request.submitForm();
                            if (submitStatus ?? false) {
                              setState(() {
                                mapData.clear();
                                getAllApplicant();
                              });
                            }
                          }
                        })
          ],

          backgroundColor: AppColors.PRIMARY_COLOR,
          title: Text(
            'VERIFICATIONS',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        body: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: isSyncLoading
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(),
                              Container(
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("Please Wait...")
                            ],
                          )
                        : gridViewWidget(),
                  ),
                ],
              )),
            ),
          ],
        ));
  }
}
