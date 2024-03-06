import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lesedi/app_color.dart';

class LocalDetails extends StatefulWidget {
  Map<String, dynamic> map = Map<String, dynamic>();
  LocalDetails({Key? key, required this.map}) : super(key: key);

  @override
  _LocalDetailsState createState() => _LocalDetailsState();
}
 ///  This the Details Screen.

class _LocalDetailsState extends State<LocalDetails> {
  @override
  Widget build(BuildContext context) {
    log(widget.map.toString());
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
            // print(role);
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
                      Text(
                        "Date of application",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['date_of_application'] != null
                          ? widget.map['date_of_application']
                          : ''),
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
                        "Account Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['account_number'] != null
                          ? widget.map['account_number'].toString()
                          : ''),
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
                        "Surname",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['surname'] != null
                          ? widget.map['surname']
                          : ''),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text("First Name", style: _style()),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        widget.map['first_name'] != null
                            ? widget.map['first_name']
                            : '',
                      ),
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
                        "Applicant ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['id_number'] != null
                          ? widget.map['id_number']
                          : ''),
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
                        "DOB",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['dob'] != null
                          ? widget.map['dob'].toString()
                          : ''),
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
                        "Age",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['dob'] != null
                          ? widget.map['dob'].toString()
                          : ''),
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
                        "Spouse ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['spouse_id_number'] != null
                          ? widget.map['spouse_id_number'].toString()
                          : ''),
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
                        "Occupant ID",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['occupant_id'] != null
                          ? widget.map['occupant_id'].toString()
                          : ''),
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
                        "Stand/Erf Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['stand_number'] != null
                          ? widget.map['stand_number'].toString()
                          : ''),
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
                        "Services Linked to Stand",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['services_linked'] != null
                          ? Row(
                              children: List.generate(
                                widget.map['services_linked'].length,
                                (index) => Text(widget.map['services_linked']
                                            [index]
                                        .toString() +
                                    ","),
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
                        "Ward Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['ward_number'] != null
                          ? widget.map['ward_number'].toString()
                          : ''),
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
                        "Eskom Account Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['eskom_account_number'] != null
                          ? widget.map['eskom_account_number'].toString()
                          : ''),
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
                        "Email",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['email'] != null
                          ? widget.map['email'].toString()
                          : ''),
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
                        "Cellphone Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['cellphone_number'] != null
                          ? widget.map['cellphone_number'].toString()
                          : ''),
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
                        "Telephone Number",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['telephone_number'] != null
                          ? widget.map['telephone_number'].toString()
                          : ''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Employment Status",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['employment_status'] != null
                          ? widget.map['employment_status']
                              .replaceAll(new RegExp('[\\W_]+'), ' ')
                              .toLowerCase()
                          : ''),
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
                        "Marital Status",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['marital_status'] != null
                          ? widget.map['marital_status']
                          : ''),
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
                        "Signature Date",
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(widget.map['signature_date']??""),
                      // Text(widget.map['signature_date'] != null
                      //     ? DateFormat('yMMMMd').format(DateTime.parse(
                      //         jsonDecode(widget.map['signature_date'])))
                      //     : ''),
                      SizedBox(
                        height: 4,
                      ),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),

//                / Text header "Welcome To" (Click to open code)
              ],
            ),
          ),
//              Divider(color: Color(0x29000000),),
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
                      Text(
                        'Applicant ID	',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['applicant_id_proof'] != null
                          ? Center(
                              child: Image.file(
                                File(widget.map['applicant_id_proof']),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              // Image(
                              //   image: CachedNetworkImageProvider(
                              //       applicant_id_proof),
                              // width: 100,
                              // fit: BoxFit.cover,
                              // ),
//                              child: Image.network(
//                              applicant_id_proof,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Spouse ID	',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['spouse_id'] != null
                          ? Center(
                              child: Image.file(
                                File(widget.map['spouse_id']),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                              child: Image.network(
//                              spouse_id,
//                              width: 100,
//                              fit: BoxFit.cover,
//                            )
                            )
                          : Text(''),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Occupant ID',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      _images(widget.map['occupant_ids[]']),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Municipal Statement of Account',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      _images(widget.map['account_statement']),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Proof of Income ',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      _images(widget.map['proof_of_incomes[]']),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      Text(
                        'Death Certificate',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      _images(widget.map['death_certificate[]']),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      Text(
                        'House Hold',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      _images(widget.map['household[]']),
                      Divider(
                        color: Color(0x29000000),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Affidavit SAPS',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['saps_affidavit'] != null
                          ? Center(
                              child: Image.file(
                                File(widget.map['saps_affidavit']),
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
                      Text(
                        'Marriage Certificate',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['marriage_certificate'] != null
                          ? Center(
                        child: Image.file(
                          File(widget.map['marriage_certificate']),
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
                      Text(
                        'Decree Divorce',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['decree_divorce'] != null
                          ? Center(
                        child: Image.file(
                          File(widget.map['decree_divorce']),
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
                      Text(
                        'Affidavits',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['affidavits'] != null
                          ? Center(
                        child: Image.file(
                          File(widget.map['affidavits']),
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
                      Text(
                        'Additional Files',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['additional_file'] != null
                          ? Center(
                        child: Image.file(
                          File(widget.map['additional_file']),
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
                      Text(
                        'Signature',
                        style: _style(),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      widget.map['signature'] != null
                          ? Center(
                              child: Image.file(
                                File(widget.map['signature']),
                                width: 100,
                                fit: BoxFit.cover,
                              ),
//                            )
                            )
                          : Text(''),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  TextStyle _style() {
    return TextStyle(
        letterSpacing: 0.0,
        color: Color(0xff141414),
        fontFamily: "Open Sans",
        fontWeight: FontWeight.w700,
        fontSize: 15.0);
  }

  _images(var imagefile) {
    print(imagefile);
    var image;
    var decodeSucceeded = false;

    try {
      if (imagefile != null) {
        image = json.decode(imagefile);
        decodeSucceeded = true;
      }
    } on FormatException catch (e) {
      print('The provided string is not valid JSON');
      image = imagefile;
    }
    print('Decoding succeeded: $decodeSucceeded');

    if (image is List) {
      return Container(
        height: 150,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            image.length,
            (index) => Image(
              image: FileImage(File(image[index])),
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else if (image != null) {
      return Center(
        child: Image.file(
          File(image),
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
