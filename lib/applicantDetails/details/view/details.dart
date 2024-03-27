import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/applicantDetails/details/notifier/details_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lesedi/utils/app_color.dart';

//Check

class ApplicantDetails extends ConsumerStatefulWidget {
  const ApplicantDetails({required this.id, super.key});

  final int id;

  @override
  ConsumerState<ApplicantDetails> createState() => _ApplicantDetailsState();
}

class _ApplicantDetailsState extends ConsumerState<ApplicantDetails> {
  final detailsProvider = ChangeNotifierProvider<DetailsNotifier>((ref) {
    return DetailsNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(detailsProvider).getApplicantDetails(applicationId: widget.id);
      print(widget.id);
      ref.read(detailsProvider).getRole();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(detailsProvider);
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
            print(notifier.role);
            Navigator.pop(context);
//            if ( role == 'field_worker'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> FieldWorkerApplicants()));
//          }
//            else if (role == 'reviewer'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> AllApplicants()));
//            }
//
//            else if (role == 'supervisor'){
//              Navigator.of(context).pushReplacement(PageRouteBuilder(pageBuilder: (_,__,___)=> SuperVisorAllApplicants()));
//            }
          },
        ),

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
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Text(
            "PERSONAL INFORMATION",
            style: TextStyle(
                letterSpacing: 0.0,
                color: Color(0xff141414),
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w700,
                fontSize: 18.0),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 40),
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
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 12, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DetailWidget(
                          title: "Date of application",
                          subtitle: notifier.models != null
                              ? DateFormat('yMMMMd').format(DateTime.parse(
                                  notifier.models?.dateOfApplication ?? ""))
                              : ''),
                      DetailWidget(
                          title: "Account Number",
                          subtitle: notifier.models?.accountNumber ?? ""),
                      DetailWidget(
                          title: "Surname",
                          subtitle: notifier.models?.surname ?? ""),
                      DetailWidget(
                          title: "First Name",
                          subtitle: notifier.models?.firstName ?? ""),
                      DetailWidget(
                          title: "Applicant ID",
                          subtitle: notifier.models?.idNumber ?? ""),
                      DetailWidget(
                          title: "DOB", subtitle: notifier.models?.dob ?? ""),
                      DetailWidget(
                          title: "Age",
                          subtitle: notifier.models?.age.toString() ?? ""),
                      DetailWidget(
                          title: "Spouse ID",
                          subtitle: notifier.models?.spouseIdNumber ?? ""),
                      DetailWidget(
                          title: "Occupant ID",
                          subtitle: notifier.models?.occupantId ?? ""),
                      DetailWidget(
                          title: "Stand/Erf Number",
                          subtitle: notifier.models?.standNumber ?? ""),
                      Text(
                        "Services Linked to Stand",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models != null
                          ? Row(
                              children: List.generate(
                                notifier.models?.servicesLinked?.length ?? 0,
                                (index) => Text(notifier
                                        .models?.servicesLinked?[index]
                                        .toString() ??
                                    "" + ","),
                              ),
                            )
                          : Text(''),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailWidget(
                          title: "Ward Number",
                          subtitle: notifier.models?.wardNumber ?? ""),
                      DetailWidget(
                          title: "Eskom Account Number",
                          subtitle: notifier.models?.eskomAccountNumber ?? ""),
                      DetailWidget(
                          title: "Email",
                          subtitle: notifier.models?.email ?? ""),
                      DetailWidget(
                          title: "Cellphone Number",
                          subtitle: notifier.models?.cellphoneNumber ?? ""),
                      DetailWidget(
                          title: "Telephone Number",
                          subtitle: notifier.models?.telephoneNumber ?? ""),
                      DetailWidget(
                          title: "Employment Status",
                          subtitle: notifier.models?.employmentStatus != null
                              ? notifier.models?.employmentStatus ??
                                  ""
                                      .replaceAll(new RegExp('[\\W_]+'), ' ')
                                      .toLowerCase()
                              : ''),
                      DetailWidget(
                          title: "Marital Status",
                          subtitle: notifier.models?.maritalStatus ?? ""),
                      Text(
                        "Bank Details",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.bankDetails == null
                          ? Text('')
                          : ListView(
                              shrinkWrap: true,
                              children: List.generate(
                                  notifier.models?.bankDetails?.length ?? 0,
                                  (index) => Container(
                                        child: Column(
                                          children: [
                                            notifier.models?.bankDetails
                                                        ?.length ==
                                                    1
                                                ? SizedBox(
                                                    height: 5,
                                                  )
                                                : Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10),
                                                    child: Center(
                                                        child: Text(
                                                      "BankDetails ${index + 1}",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'opensans',
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                  ),
                                            Row(children: [
                                              Text(
                                                "Bank Name :",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'opensans',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                notifier
                                                        .models
                                                        ?.bankDetails?[index]
                                                        .bankAccountNumber ??
                                                    "",
                                                style: TextStyle(
                                                  fontFamily: 'opensans',
                                                  fontSize: 13,
                                                ),
                                              )
                                            ]),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(children: [
                                              Text(
                                                "Account No: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'opensans',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                notifier
                                                        .models
                                                        ?.bankDetails?[index]
                                                        .bankNumber ??
                                                    "",
                                                style: TextStyle(
                                                  fontFamily: 'opensans',
                                                  fontSize: 13,
                                                ),
                                              )
                                            ]),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Row(children: [
                                              Text(
                                                "Branch Code: ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'opensans',
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                notifier
                                                        .models
                                                        ?.bankDetails?[index]
                                                        .branchCode ??
                                                    "",
                                                style: TextStyle(
                                                  fontFamily: 'opensans',
                                                  fontSize: 13,
                                                ),
                                              )
                                            ]),
                                          ],
                                        ),
                                      )),
                            ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailWidget(
                          title: "Water Meter Number",
                          subtitle: notifier.models?.water_meter_number ?? ""),
                      DetailWidget(
                          title: "Water Meter Reading",
                          subtitle: notifier.models?.water_meter_reading ?? ""),
                      DetailWidget(
                          title: "Electricity Meter Number",
                          subtitle:
                          notifier.models?.electricity_meter_number ?? ""),
                      DetailWidget(
                          title: "Electricity Meter Reading",
                          subtitle:
                          notifier.models?.electricity_meter_reading ?? ""),
                      DetailWidget(
                          title: "Signature Date",
                          subtitle: notifier.models?.signatureDate != null
                              ? DateFormat('yMMMMd').format(DateTime.parse(
                                  notifier.models?.signatureDate ?? ""))
                              : ''),
                    ],
                  ),
                ),
//
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "ATTACHMENTS",
            style: TextStyle(
                letterSpacing: 0.0,
                color: Color(0xff141414),
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w700,
                fontSize: 18.0),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 40),
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
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 12, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DetailImageWidget(
                        title: "Applicant ID ",
                        image: notifier.models?.applicantIdProof ?? "",
                      ),
                      DetailImageWidget(
                        title: "Spouse ID ",
                        image: notifier.models?.spouseId ?? "",
                      ),
                      Text(
                        'Occupant ID',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.occupantIds != null
                          ? Container(
                              height: 150,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  notifier.models?.occupantIds?.length ?? 0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models?.occupantIds?[index].url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailImageWidget(
                        title: 'Municipal Statement of Account',
                        image: notifier.models?.accountStatement ?? "",
                      ),
                      Text(
                        'Proof of Income ',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.proofOfIncomes != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.proofOfIncomes?.length ?? 0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models
                                            ?.proofOfIncomes?[index]
                                            .url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailImageWidget(
                          title: 'Affidavit SAPS',
                          image: notifier.models?.sapsAffidavit ?? ""),
                      Text(
                        'Death Certificate',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.deathCertificate != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.deathCertificate?.length ??
                                      0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models
                                            ?.deathCertificate?[index]
                                            .url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailImageWidget(
                          title: 'Decree Divorce',
                          image: notifier.models?.decreeDivorce ?? ""),
                      Text(
                        'House Hold',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.houseHoldList != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.houseHoldList?.length ?? 0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models
                                            ?.houseHoldList?[index]
                                            .url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailImageWidget(
                          title: "Marriage Certificate",
                          image: notifier.models?.marriageCertificate ?? ""),
                      Text(
                        'Affidavits',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.affidavits != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.affidavits?.length ?? 0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models?.affidavits?[index].url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Additional File',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.additionalFile != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.additionalFile?.length ?? 0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models
                                            ?.additionalFile?[index]
                                            .url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Spouse Credit Report ',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.spouseCreditReport != null
                          ? Container(
                              height: 150,
                              margin: EdgeInsets.only(top: 10),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: List.generate(
                                  notifier.models?.spouseCreditReport?.length ??
                                      0,
                                  (index) => Image(
                                    image: CachedNetworkImageProvider(notifier
                                            .models
                                            ?.spouseCreditReport?[index]
                                            .url ??
                                        ""),
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Water Meter Attachments",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.water_meter_attachments != null
                          ? Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: List.generate(
                            notifier.models?.water_meter_attachments
                                ?.length ??
                                0,
                                (index) => Image(
                              image: CachedNetworkImageProvider(notifier
                                  .models
                                  ?.water_meter_attachments?[index]
                                  .url ??
                                  ""),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : Text(''),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Electricity Meter Attachments",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.electricity_meter_attachments != null
                          ? Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: List.generate(
                            notifier.models?.electricity_meter_attachments
                                ?.length ??
                                0,
                                (index) => Image(
                              image: CachedNetworkImageProvider(notifier
                                  .models
                                  ?.electricity_meter_attachments?[index]
                                  .url ??
                                  ""),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : Text(''),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Property Attachments",
                        style: _style(),
                      ),

                      SizedBox(
                        height: 4,
                      ),
                      notifier.models?.property_meter_attachments != null
                          ? Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: List.generate(
                            notifier.models?.property_meter_attachments
                                ?.length ??
                                0,
                                (index) => Image(
                              image: CachedNetworkImageProvider(notifier
                                  .models
                                  ?.property_meter_attachments?[index]
                                  .url ??
                                  ""),
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      DetailImageWidget(
                          title: "Signature",
                          image: notifier.models?.signature ?? ""),
                    ],
                  ),
                ),
              ],
            ),
          ),

          notifier.role == 'reviewer'
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          notifier.reviewedApplicant(
                              applicationId: widget.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, right: 50, left: 50, bottom: 50),
                          child: Container(
                            height: 40.0,
                            padding: EdgeInsets.only(top: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1a000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: notifier.isLoading
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Accept',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      letterSpacing: 0.152,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showAlertDialog(
                              context: context,
                              onOkayTap: () => notifier.removeReviewedApplicant(
                                  applicationId: widget.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, right: 50, left: 50, bottom: 50),
                          child: Container(
                            height: 40.0,
                            padding: EdgeInsets.only(top: 2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppColors.PRIMARY_COLOR,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x1a000000),
                                  offset: Offset(0, 6),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: notifier.isLoadingReject
                                ? Container(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Reject',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      letterSpacing: 0.152,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : Text(''),

//           /// bills updated work
//
//           SizedBox(
//             height: 20,
//           ),
//           Text(
//             "Bills",
//             style: TextStyle(
//                 letterSpacing: 0.0,
//                 color: Color(0xff141414),
//                 fontFamily: "Open Sans",
//                 fontWeight: FontWeight.w700,
//                 fontSize: 18.0),
//           ),
//           Container(
//               alignment: Alignment.center,
//               padding:
//                   EdgeInsets.only(top: 20.0, bottom: 12, left: 20, right: 20),
//               margin: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 40),
// //          height: 665.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5.0),
//                 color: const Color(0xffffffff),
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0x29000000),
//                     offset: Offset(0, 3),
//                     blurRadius: 6,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   DetailWidget(
//                       title: "Water Meter Number",
//                       subtitle: notifier.models?.water_meter_number ?? ""),
//                   DetailWidget(
//                       title: "Water Meter Reading",
//                       subtitle: notifier.models?.water_meter_reading ?? ""),
//                   // DetailImageWidget(title: "Water Meter Attachment", image:water_meter_attachments??""),
//
//                   Text(
//                     "Water Meter Attachments",
//                     style: _style(),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   notifier.models?.water_meter_attachments != null
//                       ? Container(
//                           height: 150,
//                           margin: EdgeInsets.only(top: 10),
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             shrinkWrap: true,
//                             children: List.generate(
//                               notifier.models?.water_meter_attachments
//                                       ?.length ??
//                                   0,
//                               (index) => Image(
//                                 image: CachedNetworkImageProvider(notifier
//                                         .models
//                                         ?.water_meter_attachments?[index]
//                                         .url ??
//                                     ""),
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Text(''),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Divider(
//                     color: Color(0x29000000),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   DetailWidget(
//                       title: "Electricity Meter Number",
//                       subtitle:
//                           notifier.models?.electricity_meter_number ?? ""),
//                   DetailWidget(
//                       title: "Electricity Meter Reading",
//                       subtitle:
//                           notifier.models?.electricity_meter_reading ?? ""),
//
//                   Text(
//                     "Electricity Meter Attachments",
//                     style: _style(),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   notifier.models?.electricity_meter_attachments != null
//                       ? Container(
//                           height: 150,
//                           margin: EdgeInsets.only(top: 10),
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             shrinkWrap: true,
//                             children: List.generate(
//                               notifier.models?.electricity_meter_attachments
//                                       ?.length ??
//                                   0,
//                               (index) => Image(
//                                 image: CachedNetworkImageProvider(notifier
//                                         .models
//                                         ?.electricity_meter_attachments?[index]
//                                         .url ??
//                                     ""),
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Text(''),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Divider(
//                     color: Color(0x29000000),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     "Property Attachments",
//                     style: _style(),
//                   ),
//
//                   SizedBox(
//                     height: 4,
//                   ),
//                   notifier.models?.property_meter_attachments != null
//                       ? Container(
//                           height: 150,
//                           margin: EdgeInsets.only(top: 10),
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             shrinkWrap: true,
//                             children: List.generate(
//                               notifier.models?.property_meter_attachments
//                                       ?.length ??
//                                   0,
//                               (index) => Image(
//                                 image: CachedNetworkImageProvider(notifier
//                                         .models
//                                         ?.property_meter_attachments?[index]
//                                         .url ??
//                                     ""),
//                                 width: 100,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         )
//                       : Text(''),
//                   Divider(
//                     color: Color(0x29000000),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                 ],
//               )),
        ],
      )),
    );
  }

  showAlertDialog(
      {required BuildContext context, required Function() onOkayTap}) {
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
        onOkayTap();
        Navigator.of(context).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to Reject the Application?"),
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
}


class DetailImageWidget extends StatelessWidget {
  const DetailImageWidget(
      {required this.title, required this.image, super.key});

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _style(),
        ),
        SizedBox(
          height: 4,
        ),
        image.isNotEmpty
            ? Center(
                child: Image(
                  image: CachedNetworkImageProvider(image ?? ""),
                  width: 100,
                  fit: BoxFit.cover,
                ),
              )
            : Text(''),
        Divider(
          color: Color(0x29000000),
        ),
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _style(),
        ),
        SizedBox(
          height: 4,
        ),
        Text(subtitle),
        Divider(
          color: Color(0x29000000),
        ),
        SizedBox(
          height: 4,
        ),
      ],
    );
  }
}

TextStyle _style() {
  return TextStyle(
      letterSpacing: 0.0,
      color: Color(0xff141414),
      fontFamily: "Open Sans",
      fontWeight: FontWeight.w700,
      fontSize: 15.0);
}
