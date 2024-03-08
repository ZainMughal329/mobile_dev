class AppFlavourModel {
  String? appName;
  String? baseUrl;
  String? splashLogo;
  String? appIcon;
  String? env;

  AppFlavourModel({this.appName, this.splashLogo, this.appIcon, this.env});

  AppFlavourModel.fromJson(Map<String, dynamic> json) {
    appName = json['app_name'];
    appName = json['base_url'];
    splashLogo = json['splash_logo'];
    appIcon = json['app_icon'];
    env = json['env'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['base_url'] = this.baseUrl;
    data['splash_logo'] = this.splashLogo;
    data['app_icon'] = this.appIcon;
    data['env'] = this.env;
    return data;
  }
}