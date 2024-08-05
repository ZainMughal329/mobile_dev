import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/personal_information_B2/notifier/personal_information_B2_notifier.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/forms/personal_information_B2/notifier/widgets/my_dialog.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/widgets/common_widgets/input_field_widget.dart';

import '../../../widgets/common_widgets/coordinate_widget.dart';

class PersonalInformationB1 extends ConsumerStatefulWidget {
  final int applicant_id;
  final Function func;
  final bool previousFormSubmitted;

  PersonalInformationB1(
      this.applicant_id, this.func, this.previousFormSubmitted);

  @override
  ConsumerState<PersonalInformationB1> createState() =>
      _PersonalInformationB1State();
}

class _PersonalInformationB1State extends ConsumerState<PersonalInformationB1> {
  final personalInformationB1 =
      ChangeNotifierProvider<PersonalInformationB2Notifier>((ref) {
    return PersonalInformationB2Notifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(personalInformationB1).init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(personalInformationB1);

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
            widget.func(widget.applicant_id);
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
      backgroundColor: const Color(0xffffffff),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 40, right: 40, top: 50, bottom: 40),
//          height: 665.0,
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
                /// Text header "Welcome To" (Click to open code)
                InputFieldWidget(
                  horizontalPadding: 20,
                  verticalPadding: 10,
                  textInputType: TextInputType.number,
                  controller: notifier.standNumberController,
                  label: ' Stand/ ERF number',
                  textInputFormatter: [notifier.maskFormatter],
                  onChange: (value) {
                    print('value holder');
                    print(value.length - 32);
                    var valueHolder = notifier.maskFormatter.getUnmaskedText();
                    print(valueHolder.length);
                    var zeroList = valueHolder.padRight(27, '0');
                    notifier.formattedString = '';
                    for (int i = 0; i < zeroList.length; i++) {
                      print(i);
                      switch (i) {
                        case 3:
                        case 6:
                        case 14:
                        case 19:
                        case 23:
                          {
                            notifier.formattedString +=
                                " " + zeroList[i].toString();
                          }
                          break;
                        default:
                          {
                            notifier.formattedString += zeroList[i].toString();
                          }
                      }
                    }
                    print(notifier.formattedString);
                    setState(() {});
                    print('new string');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, bottom: 20, top: 0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return MyDialog(
                                cities: notifier.allCities,
                                selectedCities: notifier.selectedCities.isEmpty
                                    ? notifier.serviceLinkedHolder
                                    : notifier.selectedCities,
                                onSelectedCitiesListChanged: (cities) {
                                  setState(() {
                                    notifier.selectedCities = cities;
                                    notifier.serviceLinkedHolder = cities;
                                  });
                                  print(notifier.selectedCities);
                                  print('selectedCities');
                                });
//
                          });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 0, right: 0),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.elliptical(5, 5)),
                          border: Border.all(color: Colors.grey)),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Services linked to the stand",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'opensans',
                                color: Color(0xff626A76)),
                          ),
                          notifier.selectedCities?.length != 0
                              ? Row(
                                  children: List.generate(
                                      notifier.selectedCities?.length ?? 0,
                                      (index) {
                                    return Text(
                                      notifier.selectedCities?[index] ??
                                          "".toString() + ",",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'opensans',
                                          color: Color(0xff626A76)),
                                    );
                                  }),
                                )
                              : notifier.serviceLinkedHolder != null
                                  ? Row(
                                      children: List.generate(
                                          notifier.serviceLinkedHolder.length,
                                          (index) {
                                        return Text(
                                          notifier.serviceLinkedHolder[index]
                                                  .toString() +
                                              ",",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'opensans',
                                              color: Color(0xff626A76)),
                                        );
                                      }),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'opensans',
                                              color: Color(0xff626A76)),
                                        )
                                      ],
                                    )
                        ],
                      ),
                    ),
                  ),
                ),

                InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.wardNumberController,
                    label: 'Ward Number'),
                InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.eskomAccountNumberController,
                    label: 'Eskom Account Number'),
                InputFieldWidget(
                  horizontalPadding: 20,
                  verticalPadding: 10,
                  controller: notifier.emailController,
                  label: "Email",
                  textInputType: TextInputType.emailAddress,
                ),
                InputFieldWidget(
                  horizontalPadding: 20,
                  verticalPadding: 10,
                  controller: notifier.contectNumberController,
                  label: 'Cell Phone Number',
                  textInputType: TextInputType.phone,
                ),
                InputFieldWidget(
                  horizontalPadding: 20,
                  verticalPadding: 10,
                  controller: notifier.telephoneNumberController,
                  label: 'Telephone Number',
                  textInputType: TextInputType.phone,
                ),
                GestureDetector(
                    onTap: () {
                      if (FocusScope.of(context).isFirstFocus) {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      }
                      notifier.selectDateYear(context);
                    },
                    child: AbsorbPointer(
                        child: InputFieldWidget(
                      horizontalPadding: 20,
                      verticalPadding: 10,
                      controller: notifier.FinancialYearController,
                      label: 'Financial Year',
                    ))),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 20, top: 0),
                    child: CoordinateWidget(
                      lat: notifier.lat,
                      lng: notifier.lng,
                    ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                      margin: EdgeInsets.only(right: 0),
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

                  notifier.formClicked(
                    previousFormSubmitted: widget.previousFormSubmitted,
                    id: widget.applicant_id,
                    context: context,
                  );
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
