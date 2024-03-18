import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lesedi/applicants/norifier/all_applicants_notifier.dart';
import 'package:lesedi/applicants/widgets/gridview_widget.dart';
import 'package:lesedi/utils/app_color.dart';
import 'package:http/http.dart' as http;




class AllApplicants extends ConsumerStatefulWidget {
  const AllApplicants({super.key});

  @override
  ConsumerState<AllApplicants> createState() => _AllApplicantsState();
}

class _AllApplicantsState extends ConsumerState<AllApplicants> {
  final allApplicantsProvider = ChangeNotifierProvider<AllApplicantsNotifier>((ref) {
    return AllApplicantsNotifier();
  });

  void initState() {
    /// TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(allApplicantsProvider).initFunction(context: context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier=ref.watch(allApplicantsProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: [
            notifier.mapData.isEmpty
                ? SizedBox()
                : notifier.isSyncLoading
                ? SizedBox()
                : IconButton(
                icon: Icon(
                  Icons.sync,
                  color: Colors.white,
                ),
                onPressed: () async {
                  notifier.isSyncLoading = true;
                  if (notifier.mapData.isNotEmpty) {
                    // Utils.checkFormStatusAndSubmit();
                    notifier.submitStatus = await notifier.request.submitForm();
                    if (notifier.submitStatus ?? false) {
                      notifier.mapData.clear();
                      notifier.getAllApplicant();
                    }
                     notifier.setSyncLoading(false);
                  }
                })
          ],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              Navigator.of(context).pop();
            },
          ),

          backgroundColor: AppColors.PRIMARY_COLOR,
          title: Text(
            'VERIFICATIONS',
            style: TextStyle(
              fontFamily: 'Open Sans',
              fontSize: 18,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: const Color(0xffffffff),
        body: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 0),
                        height: MediaQuery.of(context).size.height * .90,
                        child: notifier.isSyncLoading
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(),
                            Container(
                              child: CircularProgressIndicator(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Please Wait...")
                          ],
                        )
                            : gridViewWidget(mapData: notifier.mapData, notifier: notifier,),
                        // Visibility(
                        //     visible: !_isVisible,
                        //     child: gridViewWidget(),
                        //     replacement: getLocalViewWidget()
                        //     // Card(
                        //     //   child: new ListTile(
                        //     //     title: Center(
                        //     //       child: new Text('No Applicants Found '),
                        //     //     ),
                        //     //   ),
                        //     // )
                        //     ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
