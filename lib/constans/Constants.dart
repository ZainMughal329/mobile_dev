class MyConstants {
  static final MyConstants myConst = new MyConstants._();
  MyConstants._();
  // package="modimolle.com.lesedi_app_icon">
  // android:label="rustenburg"
  String baseUrl = "http://213.136.94.46/"; // Rustenburg
  // String baseUrl = "http://rustenburg.herokuapp.com/"; // Rusbtenburg Stagging
  // String baseUrl = "http://173.249.14.72/"; // Modimolle
  // String baseUrl = "http://79.143.187.147/"; // lesedi
  // String baseUrl = "https://1303-182-185-173-180.ngrok.io/"; // ngRock
  bool internet;
  bool formSubmissionStatus;
  List<String> applicationsList = <String>[];
  String currentApplicantId;
}
