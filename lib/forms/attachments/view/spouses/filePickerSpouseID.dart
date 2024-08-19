import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lesedi/forms/attachments/view/occupants/occupant_viewmodel.dart';
import 'package:lesedi/forms/attachments/view/spouses/spouse_viewmodel.dart';
import 'package:lesedi/forms/personal_information_A1/notifier/personal_information_notifier.dart';

import 'package:image_picker/image_picker.dart';

class SpouseID extends ConsumerStatefulWidget {
  final int applicant_id;
  final String image_name;

  SpouseID(this.applicant_id, this.image_name);

  @override
  ConsumerState<SpouseID> createState() => _SpouseIDState();
}

class _SpouseIDState extends ConsumerState<SpouseID> {
  final personalInformationNotifier =
      ChangeNotifierProvider<PersonalInformationNotifier>((ref) {
    return PersonalInformationNotifier();
  });

  final spouseViewModelProvider =
      ChangeNotifierProvider<SpouseViewModel>((ref) {
    return SpouseViewModel();
  });

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref
          .read(spouseViewModelProvider)
          .initMethod(ref.read(personalInformationNotifier).spouseIds);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final spouseViewModel = ref.watch(spouseViewModelProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (spouseViewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: spouseViewModel.spouseData.length,
                  itemBuilder: (context, index) {
                    final spouseData = spouseViewModel.spouseData[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(spouseData.id),
                            trailing: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text(
                                        'Upload File for Spouse id: ${spouseData.id}'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text('Choose from Gallery'),
                                            onTap: () {
                                              spouseViewModel.setSpouseImages(
                                                  ImageSource.gallery, index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text('Choose from Camera'),
                                            onTap: () {
                                              spouseViewModel.setSpouseImages(
                                                  ImageSource.camera, index);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Select Image', style: TextStyle(color: Colors.black),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              // Changed from Stack to Column
                              children: [
                                Row(
                                  children: List.generate(
                                    spouseData.selectedImages.length,
                                    (imageIndex) => Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Image.file(
                                          width: 50,
                                          height: 50,
                                          spouseData.selectedImages[imageIndex],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (spouseData.isUploading)
                                  Padding(
                                    // Added padding for better visual separation
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                if (spouseData.isUploaded)
                                  Padding(
                                    // Added padding for better visual separation
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child:
                                        Icon(Icons.check, color: Colors.green),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () {
                spouseViewModel.setLoading(true);
                spouseViewModel.postSpouse(widget.applicant_id.toString());
                spouseViewModel.setLoading(false);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                      alignment: Alignment.centerRight),
                  Icon(Icons.file_upload, color: Colors.black,),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Upload',
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.2,
                        fontFamily: "Open Sans",
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
