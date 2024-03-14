import 'package:lesedi/utils/ap_flavour_configurations.dart';
import 'main.dart' as app;
import 'package:lesedi/model/app_flavour_model.dart';

void main() {
  print("modimolle is running");
  AppFlavourModel appFlavourModel =
  AppFlavourModel.fromJson(AppFlavoursConfigurations.configModimollePro);
  app.main(appFlavourModel: appFlavourModel);
}
