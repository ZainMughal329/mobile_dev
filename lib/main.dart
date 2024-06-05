import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/auth/splash/view/splash_view.dart';
import 'package:lesedi/utils/constants.dart';
import 'package:lesedi/model/app_flavour_model.dart';
import 'common_services/local_storage.dart';

Future<void> main({AppFlavourModel? appFlavourModel}) async {
  print("main file  is running");

  if(appFlavourModel!=null)
    {
      MyConstants.myConst.baseUrl=appFlavourModel.baseUrl??"";
      MyConstants.myConst.appName=appFlavourModel.appName??"";
      MyConstants.myConst.appLogo=appFlavourModel.appLogo??"";
      log("base url === > ${MyConstants.myConst.baseUrl}");
      print("this is app name ${appFlavourModel.appName}");
      print("base url === > ${MyConstants.myConst.appLogo}");
    }
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.localStorage.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState()  {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstants.myConst.appName,
      // title: 'BTF',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
//        '/': (context) => MyApp(),
        // When navigating to the "/second" route, build the SecondScreen widget.
//        '/personalinformationA1': (context) => PersonalInformationA1(),
//        '/personalinformationB1': (context) => PersonalInformationB1(190),
//        '/ApplicationStatus': (context) => ApplicationStatus(),
      },
      theme: ThemeData(
        brightness: Brightness.light,
//          primaryColor: Color(0xff626a76),
        primaryColorLight: Colors.white,
        // primaryColorBrightness: Brightness.light,
        // primaryColorBrightness: Brightness.light,
        unselectedWidgetColor: Color(0xffDE626C),
//          selectedWidgetColor:Color(0xffde626c),
//            canvasColor: Colors.transparent,

//          primaryColor: Color(0xff626a76),
//        primaryColor: Color(0xFFFF3661), //color of the main banner
        primaryColor: Color(0xffDE626C), //color of the main banner
        // accentColor: Color(0xffDE626C),
        hintColor: Color(0xffDE626C), colorScheme: ColorScheme.light().copyWith(
          primary: Color(0xffDE626C),
          secondary: Color(0xffDE626C),
        ).copyWith(background: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
