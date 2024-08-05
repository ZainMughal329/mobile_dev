import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/marital_status/notifier/marital_status_notifier.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/utils/app_color.dart';

import '../../../widgets/common_widgets/coordinate_widget.dart';

class MaritalStatus extends ConsumerStatefulWidget {
  final int applicant_id;
  final String gross_monthly_income;
  final bool previousFormSubmitted;

  MaritalStatus(
      this.applicant_id, this.gross_monthly_income, this.previousFormSubmitted);

  @override
  ConsumerState<MaritalStatus> createState() => _MaritalStatusState();
}

class _MaritalStatusState extends ConsumerState<MaritalStatus> {
  final maritalStatusProvider =
      ChangeNotifierProvider<MaritalStatusNotifier>((ref) {
    return MaritalStatusNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(widget.applicant_id);
      ref.read(maritalStatusProvider).init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(maritalStatusProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
          'MARITAL STATUS',
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
                          'Married',
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
                            notifier.checkedDI = false;
                            notifier.checkBoxValue = 'married';
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
                          'Single',
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
                            notifier.checkedUn = false;
                            notifier.checkedCh = false;
                            notifier.checkedEm = false;
                            notifier.checkedESM = false;
                            notifier.checkedDI = false;
                            notifier.checkBoxValue = 'single';
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
                          'Widowed',
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
                            notifier.checkBoxValue = 'widowed';
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
                          'Divorced',
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
                            notifier.checkedESM = value ?? false;
                            notifier.checkBoxValue = 'divorced';
                          });
                        },
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(top: 5),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30, vertical: 10),
            child: CoordinateWidget(
              lat: notifier.lat,
              lng: notifier.lng,
            ),
          ),
          SizedBox(
            height: 90,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  //    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_,__,___)=> ApplicationStatus(widget.applicant_id)));
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
                  print("Gesture Detector");
                  notifier.submitForm(
                    notifier.checkBoxValue,
                    widget.previousFormSubmitted,
                    widget.applicant_id,
                    widget.gross_monthly_income,
                    context,
                  );
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
//                alignment: Alignment.bottomRight,
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
                      child:
                          // Adobe XD layer: 'back-arrow' (shape)
                          Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            print("INK Well");
                            return notifier.submitForm(
                              notifier.checkBoxValue,
                              widget.previousFormSubmitted,
                              widget.applicant_id,
                              widget.gross_monthly_income,
                              context,
                            );
                          },
                          child: Container(
                              child: notifier.isLoading
                                  ? Container(
                                      height: 20,
                                      width: 20,
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
                        ),
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
