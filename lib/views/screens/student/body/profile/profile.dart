// import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/application/application.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/views/widgets/forms/emergency.dart';
import 'package:web_school/views/widgets/forms/family.dart';
import 'package:web_school/views/widgets/forms/personal.dart';
import 'package:web_school/views/widgets/forms/residence.dart';
import 'package:web_school/views/widgets/forms/school.dart';

@RoutePage()
class StudentWebProfileScreen extends StatefulWidget {
  const StudentWebProfileScreen({
    required this.applicationInfo,
    super.key,
  });

  final ApplicationInfo applicationInfo;

  @override
  State<StudentWebProfileScreen> createState() =>
      _StudentWebProfileScreenState();
}

class _StudentWebProfileScreenState extends State<StudentWebProfileScreen> {
  String profilePic =
      'https://firebasestorage.googleapis.com/v0/b/enrollment-8bef4.appspot.com/o/profilenew.jpg?alt=media&token=fb61f9d9-fdf2-4dd1-8fce-e4e2b12d83e7';
  final ImagePicker picker = ImagePicker();

  getInstructorDetails() async {
    var det = await FirebaseFirestore.instance
        .collection('student')
        .doc(widget.applicationInfo.userModel.id)
        .get();
    if (det.exists) {
      var details = det.data();
      if (details != null) {
        if (details.containsKey('profilePic')) {
          setState(() {
            profilePic = details['profilePic'];
          });
        }
      }
    }
  }

  changeImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        var uint8list = await image.readAsBytes();
        final ref = await FirebaseStorage.instance
            .ref()
            .child("studentprofile/${image.name}");
        var uploadTask = ref.putData(uint8list);
        final snapshot = await uploadTask.whenComplete(() {});
        var imageLink = await snapshot.ref.getDownloadURL();
        print(imageLink);

        await FirebaseFirestore.instance
            .collection('student')
            .doc(widget.applicationInfo.userModel.id)
            .update({"profilePic": imageLink});
        getInstructorDetails();
      } on Exception catch (_) {}
    }
  }

  @override
  void initState() {
    getInstructorDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AdminDB adminDB = Provider.of<AdminDB>(context);
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profile",
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              InkWell(
                onTap: () {
                  changeImage();
                },
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.black,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profilePic),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12.0),
          Divider(
            color: Colors.black,
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.black,
            )),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => adminDB.updateSchoolInfoShow(),
                      //   child: Icon(
                      //     adminDB.schoolInfoShow
                      //         ? Icons.arrow_drop_up
                      //         : Icons.arrow_drop_down,
                      //   ),
                      // ),
                      Text(
                        "School Info",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: adminDB.schoolInfoShow,
                    child: SchoolInfoForm(
                      schoolInfo: widget.applicationInfo.schoolInfo,
                      viewOnly: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => adminDB.updatePersonalInfoShow(),
                      //   child: Icon(
                      //     adminDB.personalInfoShow
                      //         ? Icons.arrow_drop_up
                      //         : Icons.arrow_drop_down,
                      //   ),
                      // ),
                      Text(
                        "Personal Info",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: adminDB.personalInfoShow,
                    child: BasicPersonalInfoForm(
                      personalInfo: widget.applicationInfo.personalInfo,
                      viewOnly: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => adminDB.updateResidenceInfoShow(),
                      //   child: Icon(
                      //     adminDB.residenceInfoShow
                      //         ? Icons.arrow_drop_up
                      //         : Icons.arrow_drop_down,
                      //   ),
                      // ),
                      Text(
                        "Residence Info",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: adminDB.residenceInfoShow,
                    child: ResidenceForm(
                      residenceInfo: widget.applicationInfo.residenceInfo,
                      viewOnly: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => adminDB.updateEmergencyInfoShow(),
                      //   child: Icon(
                      //     adminDB.emergencyInfoShow
                      //         ? Icons.arrow_drop_up
                      //         : Icons.arrow_drop_down,
                      //   ),
                      // ),
                      Text(
                        "Emergency Info",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: adminDB.emergencyInfoShow,
                    child: EmergencyForm(
                      emergencyInfo: widget.applicationInfo.emergencyInfo,
                      viewOnly: true,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () => adminDB.updateFamilyInfoShow(),
                      //   child: Icon(
                      //     adminDB.familyInfoShow
                      //         ? Icons.arrow_drop_up
                      //         : Icons.arrow_drop_down,
                      //   ),
                      // ),
                      Text(
                        "Family Info",
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Visibility(
                    visible: adminDB.familyInfoShow,
                    child: FamilyInformationForm(
                      familyInfo: widget.applicationInfo.familyInfo,
                      viewOnly: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
