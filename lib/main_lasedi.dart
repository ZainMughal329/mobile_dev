import 'package:lesedi/env/ap_flavour_configurations.dart';
import 'main.dart' as app;
import 'package:lesedi/model/app_flavour_model.dart';

void main() {
  print("lasedi is running");
  AppFlavourModel appFlavourModel =
      AppFlavourModel.fromJson(AppFlavoursConfigurations.configLesediPro);
  app.main(appFlavourModel: appFlavourModel);
}
