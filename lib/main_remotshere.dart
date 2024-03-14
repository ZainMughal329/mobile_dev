import 'package:lesedi/utils/ap_flavour_configurations.dart';
import 'main.dart' as app;
import 'package:lesedi/model/app_flavour_model.dart';

void main() {
  print("remoteshere is running");
  AppFlavourModel appFlavourModel =
  AppFlavourModel.fromJson(AppFlavoursConfigurations.configRamotesherePro);
  app.main(appFlavourModel: appFlavourModel);
}
