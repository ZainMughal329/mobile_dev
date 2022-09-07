class verificationListing {
  bool salaryIncomeIndicator;
  bool employmentStatus;
  bool employerName;
  bool creditStatus;
  bool cIPCDirectorship;
  bool iDValidation;

  verificationListing(
      {this.salaryIncomeIndicator,
        this.employmentStatus,
        this.employerName,
        this.creditStatus,
        this.cIPCDirectorship,
        this.iDValidation});

  verificationListing.fromJson(Map<String, dynamic> json) {
    salaryIncomeIndicator = json['Salary/Income Indicator'];
    employmentStatus = json['Employment Status'];
    employerName = json['Employer Name'];
    creditStatus = json['Credit Status'];
    cIPCDirectorship = json['CIPC Directorship'];
    iDValidation = json['ID Validation '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Salary/Income Indicator'] = this.salaryIncomeIndicator;
    data['Employment Status'] = this.employmentStatus;
    data['Employer Name'] = this.employerName;
    data['Credit Status'] = this.creditStatus;
    data['CIPC Directorship'] = this.cIPCDirectorship;
    data['ID Validation '] = this.iDValidation;
    return data;
  }
}
