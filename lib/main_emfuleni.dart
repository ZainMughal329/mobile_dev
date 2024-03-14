import 'package:lesedi/utils/ap_flavour_configurations.dart';
import 'main.dart' as app;
import 'package:lesedi/model/app_flavour_model.dart';


void main() {
  print("emfuleni is running");
  AppFlavourModel appFlavourModel = AppFlavourModel.fromJson(AppFlavoursConfigurations.configEmfuleniPro);
  app.main(appFlavourModel: appFlavourModel);
}