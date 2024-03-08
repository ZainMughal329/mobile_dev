import 'package:lesedi/env/ap_flavour_configurations.dart';
import 'main.dart' as app;
import 'package:lesedi/model/app_flavour_model.dart';

void main() {
  print("remoteshere is running");
  AppFlavourModel appFlavourModel =
  AppFlavourModel.fromJson(AppFlavoursConfigurations.configRemotesherePro);
  app.main(appFlavourModel: appFlavourModel);
}
