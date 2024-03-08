class AppFlavourModel {
  String? appName;
  String? baseUrl;
  String? appLogo;
  String? appIcon;
  String? env;

  AppFlavourModel({this.appName, this.appLogo, this.appIcon, this.env});

  AppFlavourModel.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    baseUrl = json['base_url'];
    appLogo = json['app_logo'];
    appIcon = json['app_icon'];
    env = json['env'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['base_url'] = this.baseUrl;
    data['splash_logo'] = this.appLogo;
    data['app_icon'] = this.appIcon;
    data['env'] = this.env;
    return data;
  }
}