import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:web_school/models/instructor.dart';
// import 'package:web_school/networks/instructor.dart';
// import 'package:web_school/values/strings/images.dart';
// import 'package:web_school/views/widgets/body/wrapper/stream.dart';
import 'package:web_school/views/widgets/fields/primary.dart';

@RoutePage()
class InstructorProfileScreen extends StatefulWidget {
  const InstructorProfileScreen({
    required this.instructor,
    super.key,
  });

  final Instructor instructor;

  @override
  State<InstructorProfileScreen> createState() =>
      _InstructorProfileScreenState();
}

class _InstructorProfileScreenState extends State<InstructorProfileScreen> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final InstructorDB instructorDB =
    //       Provider.of<InstructorDB>(context, listen: false);
    //   instructorDB.updateInstructorProfileStream();
    // });
    getInstructorDetails();
    super.initState();
  }

  String profilePic =
      'https://firebasestorage.googleapis.com/v0/b/enrollment-8bef4.appspot.com/o/profilenew.jpg?alt=media&token=fb61f9d9-fdf2-4dd1-8fce-e4e2b12d83e7';

  getInstructorDetails() async {
    var det = await FirebaseFirestore.instance
        .collection('instructor')
        .doc(widget.instructor.userModel.id)
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12.0),
              Divider(
                color: Colors.black,
              ),
              const SizedBox(height: 24.0),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(48.0),
                        child: Image.network(
                          profilePic,
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () async {
                          // await instructorDB.addFile(context);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PrimaryTextField(
                controller: TextEditingController(
                    text: widget.instructor.userModel.controlNumber),
                label: "Control Number",
                readOnly: true,
              ),
              PrimaryTextField(
                controller:
                    TextEditingController(text: widget.instructor.firstName),
                label: "First Name",
                readOnly: true,
              ),
              PrimaryTextField(
                controller:
                    TextEditingController(text: widget.instructor.lastName),
                label: "Last Name",
                readOnly: true,
              ),
              PrimaryTextField(
                controller: TextEditingController(
                    text: widget.instructor.grade?.label ?? "N/A"),
                label: "Grade",
                readOnly: true,
              ),
              PrimaryTextField(
                controller: TextEditingController(
                    text: widget.instructor.section?.label ?? "N/A"),
                label: "Section",
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
