class BankDetailsModel {
  List<BankDetailsAttributes> bankDetailsAttributes;
  int applicationId;

  BankDetailsModel({this.bankDetailsAttributes, this.applicationId});

  BankDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['bank_details_attributes'] != null) {
      bankDetailsAttributes = <BankDetailsAttributes>[];
      json['bank_details_attributes'].forEach((v) {
        bankDetailsAttributes.add(new BankDetailsAttributes.fromJson(v));
      });
    }
    applicationId = json['application_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bankDetailsAttributes != null) {
      data['bank_details_attributes'] =
          this.bankDetailsAttributes.map((v) => v.toJson()).toList();
    }
    data['application_id'] = this.applicationId;
    return data;
  }
}

class BankDetailsAttributes {
  String bankNumber;
  String bankAccountNumber;
  String branchCode;
  // int id;

  BankDetailsAttributes(
      {this.bankNumber, this.bankAccountNumber, this.branchCode});

  BankDetailsAttributes.fromJson(Map<String, dynamic> json) {
    bankNumber = json['bank_number'];
    bankAccountNumber = json['bank_account_number'];
    branchCode = json['branch_code'];
    // id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_number'] = this.bankNumber;
    data['bank_account_number'] = this.bankAccountNumber;
    data['branch_code'] = this.branchCode;
    // data['id'] = this.id;
    return data;
  }
}
