import 'package:rustenburg/forms/deathCertificate.dart';
import 'package:rustenburg/forms/filePickerAdditionalFile.dart';
import 'package:rustenburg/forms/filePickerMarriageCertificate.dart';

class ApplicantInfo {
  String firstName;
  String surname;
  String idNumber;
  String dob;
  String address;
  String cellphoneNumber;
  String telephoneNumber;
  String email;
  String accountNumber;
  String standNumber;
  List<String> servicesLinked;
  List<BankDetails> bankDetails;
  String eskomAccountNumber;
  String financialYear;
  String maritalStatus;
  String employmentStatus;
  String grossMonthlyIncome;
  String dateOfApplication;
  String signatureDate;
  String spouseIdNumber;
  String occupantId;
  String wardNumber;
  String applicantIdProof;
  String spouseId;
  String decreeDivorce;
  List<ProofOfIncomes> proofOfIncomes;
  List<SpouseCreditReport> spouseCreditReport;
  String accountStatement;
  String sapsAffidavit;
  String marriageCertificate;
  List<Affidavits> affidavits;
  List<OccupantIds> occupantIds;
  List<DeathCertificate> deathCertificate;
  List<HouseHold> houseHoldList;
  List<AdditionalFile> additionalFile;
  String signature;
  List<Remarks> remarks;
  int age;
  double userLatitude;
  double userLongitude;

  ApplicantInfo(
      {this.firstName,
        this.surname,
        this.idNumber,
        this.dob,
        this.address,
        this.cellphoneNumber,
        this.telephoneNumber,
        this.email,
        this.accountNumber,
        this.standNumber,
        this.servicesLinked,
        this.bankDetails,
        this.eskomAccountNumber,
        this.financialYear,
        this.maritalStatus,
        this.employmentStatus,
        this.grossMonthlyIncome,
        this.dateOfApplication,
        this.signatureDate,
        this.spouseIdNumber,
        this.occupantId,
        this.applicantIdProof,
        this.spouseId,
        this.houseHoldList,
        this.proofOfIncomes,
      this.spouseCreditReport,
        this.accountStatement,
        this.wardNumber,
        this.sapsAffidavit,
        this.occupantIds,
        this.decreeDivorce,
        this.affidavits,
        this.deathCertificate,
        this.marriageCertificate,
        this.additionalFile,
        this.signature,
        this.remarks,
        this.age,
        this.userLatitude,
        this.userLongitude});

  ApplicantInfo.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    surname = json['surname'];
    idNumber = json['id_number'];
    dob = json['dob'];
    address = json['address'];
    cellphoneNumber = json['cellphone_number'];
    telephoneNumber = json['telephone_number'];
    email = json['email'];
    accountNumber = json['account_number'];
    standNumber = json['stand_number'];
    servicesLinked = json['services_linked'].cast<String>();
    eskomAccountNumber = json['eskom_account_number'];
    financialYear = json['financial_year'];
    maritalStatus = json['marital_status'];
    employmentStatus = json['employment_status'];
    grossMonthlyIncome = json['gross_monthly_income'];
    dateOfApplication = json['date_of_application'];
    signatureDate = json['signature_date'];
    spouseIdNumber = json['spouse_id_number'];
    occupantId = json['occupant_id'];
    applicantIdProof = json['applicant_id_proof'];
    spouseId = json['spouse_id'];
    marriageCertificate = json['marriage_certificate'];
    decreeDivorce = json['decree_divorce'];
    wardNumber = json['ward_number'];
    if (json['proof_of_incomes'] != null) {
      proofOfIncomes = <ProofOfIncomes>[];
      json['proof_of_incomes'].forEach((v) {
        proofOfIncomes.add(new ProofOfIncomes.fromJson(v));
      });
    }
    if (json['household'] != null) {
      houseHoldList = <HouseHold>[];
      json['household'].forEach((v) {
        houseHoldList.add(new HouseHold.fromJson(v));
      });
    }

    if (json['death_certificate'] != null) {
      deathCertificate = <DeathCertificate>[];
      json['death_certificate'].forEach((v) {
        deathCertificate.add(new DeathCertificate.fromJson(v));
      });
    }


    if (json['affidavits'] != null) {
      affidavits = <Affidavits>[];
      json['affidavits'].forEach((v) {
        affidavits.add(new Affidavits.fromJson(v));
      });
    }
    accountStatement = json['account_statement'];
    sapsAffidavit = json['saps_affidavit'];
    if (json['occupant_ids'] != null) {
      occupantIds = <OccupantIds>[];
      json['occupant_ids'].forEach((v) {
        occupantIds.add(new OccupantIds.fromJson(v));
      });
    }
    // if (json['marriage_certificate'] != null) {
    //   marriageCertificate = <MarriageCertificate>[];
    //   json['marriage_certificate'].forEach((v) {
    //     marriageCertificate.add(new MarriageCertificate.fromJson(v));
    //   });
    // }
    if (json['additional_file'] != null) {
      additionalFile = <AdditionalFile>[];
      json['additional_file'].forEach((v) {
        additionalFile.add(new AdditionalFile.fromJson(v));
      });
    }
    if (json['spouse_report'] != null) {
      spouseCreditReport = <SpouseCreditReport>[];
      json['spouse_report'].forEach((v) {
        spouseCreditReport.add(new SpouseCreditReport.fromJson(v));
      });
    }
    // if (json['death_certificate'] != null) {
    //   deathCertificate = <DeathCertificate>[];
    //   json['death_certificate'].forEach((v) {
    //     deathCertificate.add(new DeathCertificate.fromJson(v));
    //   });
    // }
    // marriageCertificate = json['marriage_certificate'];
    // decreeDivorce = json['decree_divorce'];
    // if (json['affidavits'] != null) {
    //   affidavits = <Null>[];
    //   json['affidavits'].forEach((v) {
    //     affidavits.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['additional_file'] != null) {
    //   additionalFile = <Null>[];
    //   json['additional_file'].forEach((v) {
    //     additionalFile.add(new Null.fromJson(v));
    //   });
    // }
    signature = json['signature'];
    if (json['remarks'] != null) {
      remarks = <Remarks>[];
      json['remarks'].forEach((v) {
        remarks.add(new Remarks.fromJson(v));
      });
    }
    if (json['bank_details'] != null) {
      bankDetails = <BankDetails>[];
      json['bank_details'].forEach((v) {
        bankDetails.add(new BankDetails.fromJson(v));
      });
    }
    age = json['age'];
    userLatitude = json['user_latitude'];
    userLongitude = json['user_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['surname'] = this.surname;
    data['id_number'] = this.idNumber;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['cellphone_number'] = this.cellphoneNumber;
    data['telephone_number'] = this.telephoneNumber;
    data['email'] = this.email;
    data['account_number'] = this.accountNumber;
    data['stand_number'] = this.standNumber;
    data['services_linked'] = this.servicesLinked;
    data['eskom_account_number'] = this.eskomAccountNumber;
    data['financial_year'] = this.financialYear;
    data['marital_status'] = this.maritalStatus;
    data['employment_status'] = this.employmentStatus;
    data['gross_monthly_income'] = this.grossMonthlyIncome;
    data['date_of_application'] = this.dateOfApplication;
    data['signature_date'] = this.signatureDate;
    data['marriage_certificate'] = this.marriageCertificate;
    data['spouse_id_number'] = this.spouseIdNumber;
    data['occupant_id'] = this.occupantId;
    data['applicant_id_proof'] = this.applicantIdProof;
    data['spouse_id'] = this.spouseId;
    if (this.proofOfIncomes != null) {
      data['proof_of_incomes'] =
          this.proofOfIncomes.map((v) => v.toJson()).toList();
    }
    // if (this.marriageCertificate != null) {
    //   data['marriage_certificate'] =
    //       this.marriageCertificate.map((v) => v.toJson()).toList();
    // }
    if (this.additionalFile != null) {
      data['additional_file'] =
          this.additionalFile.map((v) => v.toJson()).toList();
    }
    if (this.deathCertificate != null) {
      data['death_certificate'] =
          this.deathCertificate.map((v) => v.toJson()).toList();
    }
    if (this.houseHoldList != null) {
      data['household'] =
          this.houseHoldList.map((v) => v.toJson()).toList();
    }
    data['account_statement'] = this.accountStatement;
    data['saps_affidavit'] = this.sapsAffidavit;
    if (this.occupantIds != null) {
      data['occupant_ids'] = this.occupantIds.map((v) => v.toJson()).toList();
    }
    // if (this.household != null) {
    //   data['household'] = this.household.map((v) => v.toJson()).toList();
    // }
    // if (this.deathCertificate != null) {
    //   data['death_certificate'] =
    //       this.deathCertificate.map((v) => v.toJson()).toList();
    // }
    // data['marriage_certificate'] = this.marriageCertificate;
    // data['decree_divorce'] = this.decreeDivorce;
    // if (this.affidavits != null) {
    //   data['affidavits'] = this.affidavits.map((v) => v.toJson()).toList();
    // }
    // if (this.additionalFile != null) {
    //   data['additional_file'] =
    //       this.additionalFile.map((v) => v.toJson()).toList();
    // }
    data['signature'] = this.signature;
    if (this.remarks != null) {
      data['remarks'] = this.remarks.map((v) => v.toJson()).toList();
    }
    if (this.bankDetails != null) {
      data['bank_details'] = this.bankDetails.map((v) => v.toJson()).toList();
    }
    data['age'] = this.age;
    data['user_latitude'] = this.userLatitude;
    data['user_longitude'] = this.userLongitude;
    return data;
  }
}

class ProofOfIncomes {
  String url;
  String contentType;

  ProofOfIncomes({this.url, this.contentType});

  ProofOfIncomes.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}
class BankDetails {
  int id;
  String bankNumber;
  String bankAccountNumber;
  String branchCode;
  int applicationId;
  String createdAt;
  String updatedAt;

  BankDetails(
      {this.id,
        this.bankNumber,
        this.bankAccountNumber,
        this.branchCode,
        this.applicationId,
        this.createdAt,
        this.updatedAt});

  BankDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankNumber = json['bank_number'];
    bankAccountNumber = json['bank_account_number'];
    branchCode = json['branch_code'];
    applicationId = json['application_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_number'] = this.bankNumber;
    data['bank_account_number'] = this.bankAccountNumber;
    data['branch_code'] = this.branchCode;
    data['application_id'] = this.applicationId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SpouseCreditReport {
  String url;
  String contentType;

  SpouseCreditReport({this.url, this.contentType});

  SpouseCreditReport.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}

class DeathCertificate {
  String url;
  String contentType;

  DeathCertificate({this.url, this.contentType});

  DeathCertificate.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}

class HouseHold {
  String url;
  String contentType;

  HouseHold({this.url, this.contentType});

  HouseHold.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}


class Affidavits {
  String url;
  String contentType;

  Affidavits({this.url, this.contentType});

  Affidavits.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}

class MarriageCertificate {
  String url;
  String contentType;

  MarriageCertificate({this.url, this.contentType});

  MarriageCertificate.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}
class AdditionalFile {
  String url;
  String contentType;

  AdditionalFile({this.url, this.contentType});

  AdditionalFile.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}

class OccupantIds {
  String url;
  String contentType;

  OccupantIds({this.url, this.contentType});

  OccupantIds.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}

class AdditionalIds {
  String url;
  String contentType;

  AdditionalIds({this.url, this.contentType});

  AdditionalIds.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}
class AffidavitsIds {
  String url;
  String contentType;

  AffidavitsIds({this.url, this.contentType});

  AffidavitsIds.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    contentType = json['content_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['content_type'] = this.contentType;
    return data;
  }
}
class Remarks {
  String userType;
  String remarks;

  Remarks({this.userType, this.remarks});

  Remarks.fromJson(Map<String, dynamic> json) {
    userType = json['user_type'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_type'] = this.userType;
    data['remarks'] = this.remarks;
    return data;
  }
}
