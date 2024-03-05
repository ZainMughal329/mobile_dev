import 'dart:developer';
import 'package:lesedi/applicantDetails/localDetails.dart';
import 'package:lesedi/constans/Constants.dart';
import 'package:lesedi/helpers/local_storage.dart';
import 'package:lesedi/model/applicants.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/networkRequest/services_request.dart';
import 'dart:convert';
import 'package:lesedi/applicantDetails/details.dart';
import 'package:lesedi/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lesedi/app_color.dart';

class FieldWorkerApplicants extends StatefulWidget {
  @override
  _FieldWorkerApplicantsState createState() => _FieldWorkerApplicantsState();
}

class _FieldWorkerApplicantsState extends State<FieldWorkerApplicants> {
  @override
  @override
  void initState() {
    super.initState();
    print('daya');
    getLocalData();
    getAllApplicant();
  }

  List<Map<String, dynamic>> mapData = <Map<String, dynamic>>[];
  ServicesRequest request = ServicesRequest();
  bool? submitStatus;
  bool isLoading = false;
  bool isSyncLoading = false;
  getLocalData() async {
    // LocalStorage.localStorage.checkIfFileExists();
    print("Get Local Data Called");
    // List<String> emptylist = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // LocalStorage.localStorage.deleteCacheDir();
    // LocalStorage.localStorage.clearApplicationsID();
    // sharedPreferences.setStringList('applicationIds', emptylist);
    // MyConstants.myConst.applicationsList =
    //     sharedPreferences.getStringList('applicationIds');
    var localData = sharedPreferences.getStringList('applicationIds');
    log('Local Data ::::  ${localData.toString()}');
    if (localData != null) {
      // localData.removeAt(0);
      // localData.removeAt(0);
      // localData.removeAt(0);
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
  bool _isVisible = true;
  getAllApplicant() async {
    await request.ifInternetAvailable();
    if (MyConstants.myConst.internet ?? false) {
      setState(() {
        isLoading = true;
      });
      List<NodoPOJO> responseM = [];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var userID = sharedPreferences.getString('userID');
      var authToken = sharedPreferences.getString('auth-token');
      var jsonResponse;
      http.Response response = await http.get(
          Uri.parse(
              "${MyConstants.myConst.baseUrl}api/v1/users/all_my_applications"),
          headers: {
            'Content-Type': 'application/json',
            'uuid': userID??"",
            'Authentication': authToken??""
          });
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        print('dataaaa');
        print(jsonResponse);
//      if (jsonResponse['message'] == 'No such applicants found!'){
//        showToastMessage(jsonResponse['message'].toString().replaceAll("[\\[\\](){}]",""));
//      }

        List<dynamic> dataHolder = jsonResponse;
        print(jsonResponse);
        for (int j = 0; j < dataHolder.length; j++) {
          var dataSort = dataHolder.toList()[j];
          print("datsoort ===> $dataSort");
          NodoPOJO models = NodoPOJO.fromJson(dataSort);
          responseM.add(models);
          print(responseM[0].extremo1);
        }

        setState(() {
          print('done');
          models = responseM;
          isLoading = false;
          if (models.length == 0) {
            _isVisible = !_isVisible;
          }
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
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  reviewedApplicant(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userID = sharedPreferences.getString('userID');
    var authToken = sharedPreferences.getString('auth-token');
    var jsonResponse;
    http.Response response = await http.put(
        Uri.parse(
            "${MyConstants.myConst.baseUrl}api/v1/users/applicant_reviewed?application_id=$id&reviewed='true'"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
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
            "${MyConstants.myConst.baseUrl}api/v1/users/applicant_reviewed?application_id=$id&reviewed='false'"),
        headers: {
          'Content-Type': 'application/json',
          'uuid': userID??"",
          'Authentication': authToken??""
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
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
            physics: NeverScrollableScrollPhysics(),
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
                  // Remove the item from the data source.
                  // setState(() {
                  //   mapData.removeAt(position);
                  //   MyConstants.myConst.currentApplicantId =
                  //       mapData[position]['id_number'];
                  //   LocalStorage.localStorage.clearCurrentApplication();
                  // });

                  // Show a red background as the item is swiped away.

                  // Then show a snackbar.
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
        isLoading
            ? Container(
          height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
//          reverse: true,
                itemCount: models.length,
//          gridDelegate:
//              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                itemBuilder: (context, position) {
//            MediaQueryData mediaQueryData = MediaQuery.of(context);

                  return InkWell(
                    onTap: () {
                      print(models[position].extremo1);
                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              ApplicantDetails(models[position].extremo1??0)));
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
                                color: AppColors.PRIMARY_COLOR,
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
//                                               child: Text(
//                                                 models[position].extremo3 !=
//                                                     null
//                                                     ? models[position].extremo3
//                                                     : '',
                                              child: Text(
                                                models[position].extremo3??"",
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
                                            // Text(
                                            //   models[position].extremo2 != null
                                            //       ? models[position].extremo2
                                            //       : ''
                                            Text(
                                              models[position].extremo2??"",
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
                  );
                }),
        SizedBox(height: 20,)
      ],
    );

    // if (models.length == 0) {
    //   return ;
    // }

    // return ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            mapData.isEmpty
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
                            setState(() {
                              isSyncLoading = true;
                            });
                            submitStatus = await request.submitForm();
                            if (submitStatus ?? false) {
                              setState(() {
                                mapData.clear();
                                getAllApplicant();
                                // isSyncLoading = false;
                              });
                            }

                            setState(() {
                              isSyncLoading = false;
                            });
                          }
                          // Submit all forms
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
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
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
                    // Visibility(
                    //     visible: _isVisible,
                    //     child: gridViewWidget(),
                    // ),
                  )
                ],
              )),
            ),
          ],
        ));
  }
}
