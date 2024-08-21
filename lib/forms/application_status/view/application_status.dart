import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/application_status/notifier/application_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/widgets/common_widgets/input_field_widget.dart';
import 'package:lesedi/utils/app_color.dart';

import '../../../utils/constants.dart';
import '../../../widgets/common_widgets/coordinate_widget.dart';

class ApplicationStatus extends ConsumerStatefulWidget {
  final int applicant_id;
  final bool previousFormSubmitted;

  ApplicationStatus(this.applicant_id, this.previousFormSubmitted);

  @override
  ConsumerState<ApplicationStatus> createState() => _ApplicationStatusState();
}

class _ApplicationStatusState extends ConsumerState<ApplicationStatus> {
  final applicationStatusProvider =
      ChangeNotifierProvider<ApplicationStatusNotifier>((ref) {
    return ApplicationStatusNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(widget.applicant_id);
      ref.read(applicationStatusProvider).init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(applicationStatusProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              MyConstants.myConst.appLogo,
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xffde626c),
        title: Text(
          'EMPLOYMENT STATUS',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 18,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 40),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 10),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        dense: false,
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Pensioner',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checked,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checked = value;
                            notifier.checkedG = false;
                            notifier.checkedUn = false;
                            notifier.checkedCh = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedGMI = false;
                            notifier.checkedDI = false;

                            notifier.checkBoxValue = 'pensioner';
                            print(notifier.checkBoxValue);
                            print(notifier.checked);
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Grantee',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checkedG,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedG = value;
                            notifier.checked = false;
                            notifier.heckedUn = false;
                            notifier.checkedCh = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedGMI = false;
                            notifier.checkedDI = false;
                            notifier.checkBoxValue = 'grantee';
                            print(notifier.checkBoxValue);
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Unemployed',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checkedUn,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedG = false;
                            notifier.checked = false;
                            notifier.checkedCh = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedDI = false;
                            notifier.checkedUn = value;
                            notifier.checkedGMI = false;
                            notifier.checkBoxValue = 'unemployed';
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Childheaded Houshold',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checkedCh,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedCh = value;
                            notifier.checkedG = false;
                            notifier.checked = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedDI = false;
                            notifier.checkedUn = false;
                            notifier.checkedGMI = false;
                            notifier.checkBoxValue = 'childheaded_household';
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Employed',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checkedEm,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedCh = false;
                            notifier.checkedG = false;
                            notifier.checked = false;
                            notifier.checkedESM = false;
                            notifier.checkedDI = false;
                            notifier.checkedUn = false;
                            notifier.checkedEm = value;
                            notifier.checkedGMI = false;
                            notifier.checkBoxValue = 'employed';
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Employed by Government ',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.checkedESM,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedCh = false;
                            notifier.checkedG = false;
                            notifier.checked = false;
                            notifier.checkedDI = false;
                            notifier.checkedUn = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = value;
                            notifier.checkedGMI = false;
                            notifier.checkBoxValue = 'employ_by_government';
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0.0, right: 20, bottom: 0, top: 0),
                  child: Container(
                      height: 50,
                      child: CheckboxListTile(
                        checkColor: Color(0xffffffff),
                        activeColor: Color(0xffde626c),
                        title: Text(
                          'Director',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 12,
                            color: const Color(0xff6f6f6f),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        value: notifier.heckedDI,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (bool? value) {
                          setState(() {
                            notifier.checkedCh = false;
                            notifier.checkedG = false;
                            notifier.checked = false;
                            notifier.checkedUn = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedDI = value;
                            notifier.checkedGMI = false;
                            notifier.checkBoxValue = 'director';
                          });
                        },
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xffffffff),
                      border: Border(
                        bottom: BorderSide(
                          //                    <--- top side
                          color: Color(0xffEEEEEE),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(' Household Gross Monthly Income (R)'),
                  ),
                ),
                InputFieldWidget(
                  horizontalPadding: 30,
                  verticalPadding: 10,
                  controller: notifier.grossMonthlyController,
                  label: "Gross Monthly Income (R)",
                  textInputType: TextInputType.number,
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Remarks'),
                  ),
                ),
                InputFieldWidget(
                  horizontalPadding: 30,
                  verticalPadding: 10,
                  controller: notifier.remarksController,
                  label: "Remarks",
                  textInputType: TextInputType.text,
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: CoordinateWidget(
                    lat: notifier.lat,
                    lng: notifier.lng,
                  ),
                ),

//
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
//                      Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> PersonalInformationB1(widget.applicant_id)));
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
//                alignment: Alignment.bottomRight,
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color(0xff4d4d4d),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(-4, 0),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child:
                          // Adobe XD layer: 'back-arrow' (shape)
                          Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: Icon(
                          Icons.arrow_back_ios,
                          size: 30,
                          color: Colors.white,
                        )),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    currentFocus.focusedChild?.unfocus();
                  }
                  if (!notifier.isLoading) {
                    notifier.submitForm(
                        notifier.checkBoxValue,
                        widget.previousFormSubmitted,
                        widget.applicant_id,
                        context);
                  }
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
//                alignment: Alignment.bottomRight,
                      width: 80.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AppColors.PRIMARY_COLOR != null
                            ? AppColors.PRIMARY_COLOR
                            : Color(0xffDE626C),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x29000000),
                            offset: Offset(-4, 0),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child:
                          // Adobe XD layer: 'back-arrow' (shape)
                          Align(
                        alignment: Alignment.center,
                        child: Container(
                            child: notifier.isLoading
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : Icon(
                                    Icons.arrow_forward_ios,
                                    size: 30,
                                    color: Colors.white,
                                  )),
                      )),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
