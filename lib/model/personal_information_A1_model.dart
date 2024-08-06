class PersonalInformationA1Model {
int? id;
String? accountNumber;
String? surname;
String? firstName;
String? idNumber;
String? postalAddress1;
String? postalAddress2;
String? postalCode;
String? cellPhoneNumber;

PersonalInformationA1Model(
    {this.id,
      this.accountNumber,
      this.surname,
      this.firstName,
      this.idNumber,
      this.postalAddress1,
      this.postalAddress2,
      this.postalCode,
      this.cellPhoneNumber});

PersonalInformationA1Model.fromJson(Map<String, dynamic> json) {
id = json['id'];
accountNumber = json['account_number'];
surname = json['surname'];
firstName = json['first_name'];
idNumber = json['id_number'];
postalAddress1 = json['postal_address_1'];
postalAddress2 = json['postal_address_2'];
postalCode = json['postal_code'];
cellPhoneNumber = json['cell_phone_number'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['account_number'] = this.accountNumber;
data['surname'] = this.surname;
data['first_name'] = this.firstName;
data['id_number'] = this.idNumber;
data['postal_address_1'] = this.postalAddress1;
data['postal_address_2'] = this.postalAddress2;
data['postal_code'] = this.postalCode;
data['cell_phone_number'] = this.cellPhoneNumber;
return data;
}
}