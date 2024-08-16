import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/dashboard/view/dashboard_view.dart';
import 'package:lesedi/forms/personal_information_A1/notifier/personal_information_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:lesedi/widgets/common_widgets/coordinate_widget.dart';
import 'package:lesedi/widgets/common_widgets/input_field_widget.dart';

class PersonalInformationA1 extends ConsumerStatefulWidget {
  final String userRole;
  final int applicant_id;
  final List scannerList = [];

  PersonalInformationA1(this.userRole, this.applicant_id);

  @override
  ConsumerState<PersonalInformationA1> createState() =>
      _PersonalInformationA1State();
}

class _PersonalInformationA1State extends ConsumerState<PersonalInformationA1> {
  final personalInformationA1 =
      ChangeNotifierProvider<PersonalInformationNotifier>((ref) {
    return PersonalInformationNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(personalInformationA1).init();
    });

    super.initState();
  }

  TextStyle valueTextStyle = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'opensans');
  TextStyle textTextStyle = TextStyle(fontSize: 13, fontFamily: 'opensans');
  TextStyle buttonTextStyle =
      TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'opensans');

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(personalInformationA1);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            showAlertDialog(context, widget.userRole, widget.applicant_id);
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
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 40),
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
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                  ),

                  GestureDetector(
                    onTap: () => notifier.selectDate(context),
                    child: AbsorbPointer(
                      child: InputFieldWidget(
                        horizontalPadding: 20,
                        verticalPadding: 10,
                        controller: notifier.dateOfApplicationController,
                        label: 'Date of Application',
                      ),
                    ),
                  ),
                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.accountNumberController,
                    label: 'Account Number',
                    // textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        notifier.fetchUserDetailsWithAccountNumber(value);
                      }
                    },
                  ),
                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.surNameController,
                    label: 'Surname',
                  ),

                  /// Text header "Welcome To" (Click to open code)
                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.firstNameController,
                    label: 'First Name',
                  ),

                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.applicantIDController,
                    label: 'Applicant ID',
                    hasSuffix: true,
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty &&
                          notifier.accountNumberController.text.isEmpty) {
                        notifier.fetchUserDetailsWithIdNumber(value);
                      }
                    },
                    suffixIcon: IconButton(
                      icon: Icon(Icons.scanner),
                      color: AppColors.PRIMARY_COLOR,
                      onPressed: () async {
                        final result = await notifier.scan(1);
                        notifier.DataResult = result.join('.join');
                      },
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//                        (age > -1)
//                            ?
                      Column(
                        children: <Widget>[
                          Builder(
                            builder: (context) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  primaryColor: AppColors.PRIMARY_COLOR,
                                  //color of the main banner
                                  hintColor: AppColors.PRIMARY_COLOR,
                                  colorScheme: ColorScheme.light().copyWith(
                                    primary: AppColors.PRIMARY_COLOR,
                                    secondary: AppColors.PRIMARY_COLOR,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    DateTime birthDate =
                                        await notifier.selectDatePicker(
                                            context, DateTime(1912),
                                            lastDate: DateTime.now());
                                    final df = new DateFormat('dd-MMM-yyyy');
                                    notifier.birthDate = df.format(birthDate);
                                    notifier.age =
                                        notifier.calculateAge(birthDate);

                                    setState(() {});
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.elliptical(5, 5)),
                                        border: Border.all(color: Colors.grey)),
                                    padding: EdgeInsets.all(18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "DOB: ",
                                          style: textTextStyle,
                                        ),
                                        Text(
                                          "${notifier.birthDate ?? ""}",
                                          style: valueTextStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: EdgeInsets.all(18),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.elliptical(5, 5)),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Age: ",
                                  style: textTextStyle,
                                ),
                                (notifier.age > -1)
                                    ? Text(
                                        "${notifier.age}",
                                        style: valueTextStyle,
                                      )
                                    : Text('')
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),

          InputFieldWidget(
            horizontalPadding: 20,
            verticalPadding: 10,
            controller: notifier.spouseIDController,
            label: 'Spouse ID',
            hasSuffix: true,
            suffixIcon: IconButton(
              icon: Icon(Icons.scanner),
              color: AppColors.PRIMARY_COLOR,
              onPressed: () async {
                final result = await notifier.scan(2);
                notifier.DataResult = result.join('.join');
              },
            ),
            onFieldSubmitted: (value) {
              notifier.addSpouse(value);
              notifier.spouseIDController.text = value;
            },
          ),
          IconButton(
            onPressed: () {
              // Call addOccupant with the current value from the text field
              final spouseId =
              notifier.spouseIDController.text.trim();
              notifier.addSpouse(spouseId);
              notifier.spouseIDController.clear();
            },
            icon: Icon(Icons.add),
            color: AppColors.PRIMARY_COLOR,
          ),

          Wrap(
            spacing: 4.0,
            children: notifier.spouseIds.map((spouseId) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5.0),
                padding: EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 4.0), // Reduced padding
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      spouseId,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8.0),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Colors.red, size: 16),
                      onPressed: () {
                        notifier.removeSpouse(spouseId);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.dependentIDController,
                    label: 'Occupant ID',
                    hasSuffix: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.scanner),
                      color: AppColors.PRIMARY_COLOR,
                      onPressed: () async {
                        final result = await notifier.scan(3);
                        notifier.DataResult = result.join('.join');
                      },
                    ),
                    onFieldSubmitted: (value) {
                      notifier.addOccupant(value);
                      notifier.dependentIDController.text = value;
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      // Call addOccupant with the current value from the text field
                      final occupantId =
                          notifier.dependentIDController.text.trim();
                      notifier.addOccupant(occupantId);
                      notifier.dependentIDController.clear();
                    },
                    icon: Icon(Icons.add),
                    color: AppColors.PRIMARY_COLOR,
                  ),

                  Wrap(
                    spacing: 4.0,
                    children: notifier.occupantIds.map((occupantId) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0), // Reduced padding
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              occupantId,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 8.0),
                            IconButton(
                              icon: Icon(Icons.close,
                                  color: Colors.red, size: 16),
                              onPressed: () {
                                notifier.removeOccupant(occupantId);
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  InputFieldWidget(
                    horizontalPadding: 20,
                    verticalPadding: 10,
                    controller: notifier.addressController,
                    label: 'Address',
                  ),

                  Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, bottom: 20, top: 0),
                      child: CoordinateWidget(
                        lat: notifier.lat,
                        lng: notifier.lng,
                      )),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  currentFocus.focusedChild?.unfocus();
                }
                notifier.formClicked(context: context);
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                    margin: EdgeInsets.only(right: 0, bottom: 20),
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
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, userRole, id) {
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
          pageBuilder: (_, __, ___) =>
              Dashboard(userRole: userRole, applicant_id: id)));
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
