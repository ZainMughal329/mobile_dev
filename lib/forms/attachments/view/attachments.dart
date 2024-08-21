import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/attachments/notifier/attachements_notifier.dart';
import 'package:lesedi/forms/deathCertificate.dart';
import 'package:lesedi/forms/filePickerAdditionalFile.dart';
import 'package:lesedi/forms/filePickerSapsAffidavit.dart';
import 'package:lesedi/forms/filePickerAffidavits.dart';
import 'package:lesedi/forms/filePickerDegreeDivorce.dart';
import 'package:lesedi/forms/filePickerGromeMonthIncome.dart';
import 'package:lesedi/forms/attachments/view/spouses/filePickerSpouseID.dart';
import 'package:lesedi/forms/filerPickerAccountStatment.dart';
import 'package:lesedi/forms/household.dart';
import 'package:lesedi/forms/personal_information_A1/notifier/personal_information_notifier.dart';
import 'package:lesedi/forms/water_and_electricity_information/view/water_and_electricity_info_view.dart';
import 'package:lesedi/utils/globals.dart';
import 'package:lesedi/widgets/common_widgets/coordinate_widget.dart';
import '../../../utils/constants.dart';
import 'occupants/occupant_id.dart';
import 'package:lesedi/utils/app_color.dart';
import '../../filePickerApplicationID.dart';
import '../../filePickerMarriageCertificate.dart';
import '../../filePickerSpouseReport.dart';

class Attachments extends ConsumerStatefulWidget {
  final int applicant_id;
  final String gross_monthly_income;
  final bool previousFormSubmitted;

  Attachments(
      {required this.applicant_id,
      required this.gross_monthly_income,
      required this.previousFormSubmitted});

  @override
  ConsumerState<Attachments> createState() => _AttachmentsState();
}

class _AttachmentsState extends ConsumerState<Attachments> {
  final attachmentsProvider =
      ChangeNotifierProvider<AttachmentsNotifier>((ref) {
    return AttachmentsNotifier();
  });
  final occupantProvider =
      ChangeNotifierProvider<PersonalInformationNotifier>((ref) {
    return PersonalInformationNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(widget.gross_monthly_income);
      ref.read(attachmentsProvider).init();
      ref.read(occupantProvider).occupantIds;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(attachmentsProvider);
    final occupantNotifier = ref.watch(occupantProvider);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(MyConstants.myConst.appLogo),
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
        backgroundColor: AppColors.PRIMARY_COLOR,
        title: Text(
          'ATTACHMENTS',
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
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Applicant ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FileHolderApplicationID(
                    widget.applicant_id, 'applicant_id_proof'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Spouse ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                    height: 300,
                    child: SpouseID(widget.applicant_id, 'spouse_id')),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Occupant ID',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                    height: 300,
                    child: OccupantID(widget.applicant_id, 'occupant_ids')),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Gross Monthly Income (R) ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FileHolderGrossMonth(widget.applicant_id, 'proof_of_incomes'),
                Divider(),
                Padding(
                  padding: widget.gross_monthly_income.isNotEmpty
                      ? EdgeInsets.only(
                          left: 30, right: 30, bottom: 20, top: 20)
                      : EdgeInsets.only(
                          left: 30, right: 30, bottom: 20, top: 0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Municipal Statement of account ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FileHolderAccountStatement(
                    widget.applicant_id, 'account_statement'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Affidavit SAPS ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FileHolderAsapsAffidavit(widget.applicant_id, 'saps_affidavit'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Household ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                HouseHold(widget.applicant_id, 'household'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Death Certificate ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                DeathCertificate(widget.applicant_id, 'death_certificate'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Marriage Certificate',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                MarriageCertificate(
                    widget.applicant_id, 'marriage_certificate'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Decree Divorce',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                DecreeDivorce(widget.applicant_id, 'degree_divorce'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Affidavits',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Affidavits(widget.applicant_id, 'affidavits'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Additional File',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FileHolderAdditional(widget.applicant_id, 'additional'),
                Divider(),
                Padding(
                  padding:
                      EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Spouse credit report',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                FilePickerSpouseCreditReport(
                    widget.applicant_id, 'spouse_reports'),
                Divider(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 0),
            child: CoordinateWidget(
              lat: notifier.lat,
              lng: notifier.lng,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: InkWell(
              onTap: () async {
                notifier.setLoading(true);
                // await checkFormStatus();
                print("Applicant ID :::: ${widget.applicant_id}");
                print(
                    "Previous Form Submitted ::: ${widget.previousFormSubmitted}");
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => WaterAndElectricityView(
                        applicant_id: widget.applicant_id,
                        previousFormSubmitted: widget.previousFormSubmitted)));
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
          ),
        ],
      )),
    );
  }
}
