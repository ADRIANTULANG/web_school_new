import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_school/models/instructor.dart';
import 'package:web_school/networks/admin.dart';
import 'package:web_school/networks/commons.dart';
import 'package:web_school/views/screens/admin/navigation_bar/navigation_bar.dart';
import 'package:web_school/views/widgets/buttons/primary.dart';
import 'package:web_school/views/widgets/fields/secondart.dart';

@RoutePage()
class AdminEditInstructorScreen extends StatefulWidget {
  const AdminEditInstructorScreen({
    required this.instructorData,
    super.key,
  });

  final Instructor instructorData;

  @override
  State<AdminEditInstructorScreen> createState() =>
      _AdminEditInstructorScreenState();
}

class _AdminEditInstructorScreenState extends State<AdminEditInstructorScreen> {
  List strandList = [];
  List sectionList = [];
  List semesterList = [];
  List subjectList = [];
  List gradeList = [];

  String selectedSectionID = '';
  Map selectedSectionMap = {};
  String selectedStrandID = '';
  Map selectedStrandMap = {};
  String selectedSemesterID = '';
  Map selectedSemesterMap = {};
  String selectedGradeID = '';

  String selectedLevel = '';
  Map selectedGrade = {};
  Map selectedSection = {};

  getStrands() async {
    var res = await FirebaseFirestore.instance.collection('strand').get();
    var strands = res.docs;
    List tempList = [];
    for (var i = 0; i < strands.length; i++) {
      Map data = strands[i].data();
      data['id'] = strands[i].id;
      tempList.add(data);
    }
    setState(() {
      strandList = tempList;
    });
    if (widget.instructorData.strand != null) {
      for (var i = 0; i < strandList.length; i++) {
        if (strandList[i]['id'] == widget.instructorData.strand!.id) {
          selectedStrandID = strandList[i]['id'];
          selectedStrandMap = strandList[i];
        }
      }
    }
  }

  getSemester() async {
    var res = await FirebaseFirestore.instance.collection('semester').get();
    var strands = res.docs;
    List tempList = [];
    for (var i = 0; i < strands.length; i++) {
      Map data = strands[i].data();
      data['id'] = strands[i].id;
      tempList.add(data);
    }
    setState(() {
      semesterList = tempList;
    });
    if (widget.instructorData.subject!.isNotEmpty) {
      var resss = await FirebaseFirestore.instance
          .collection('subjects')
          .where('id', isEqualTo: widget.instructorData.subject![0].id)
          .get();
      var subjs = resss.docs;
      for (var i = 0; i < subjs.length; i++) {
        selectedSemesterID = subjs[i]['semester_id'];
        selectedSemesterMap = {
          "id": subjs[i]['semester_id'],
          "name": subjs[i]['semester']
        };
      }
    }
  }

  getSections() async {
    var res = await FirebaseFirestore.instance.collection('sectionList').get();
    var sections = res.docs;
    List tempList = [];
    for (var i = 0; i < sections.length; i++) {
      Map data = sections[i].data();
      data['id'] = sections[i].id;
      tempList.add(data);
    }
    setState(() {
      sectionList = tempList;
    });
    for (var i = 0; i < sectionList.length; i++) {
      if (sectionList[i]['id'].toString() ==
          widget.instructorData.section!.id) {
        selectedSectionID = sectionList[i]['id'].toString();
        selectedSectionMap = sectionList[i];
      }
    }
  }

  getGrade() async {
    for (var i = 0; i < AdminDB().gradeList.length; i++) {
      gradeList.add({
        "id": AdminDB().gradeList[i].id,
        "label": AdminDB().gradeList[i].label,
      });
    }

    for (var i = 0; i < gradeList.length; i++) {
      if (widget.instructorData.grade!.id! == gradeList[i]['id']) {
        selectedGradeID = gradeList[i]['id'];
        selectedGrade = {
          "id": gradeList[i]['id'].toString(),
          "label": gradeList[i]['label'],
        };
      }
    }
    if (widget.instructorData.grade!.id! == "4" ||
        widget.instructorData.grade!.id! == "5") {
      selectedLevel = 'SENIOR';
    } else {
      selectedLevel = 'JUNIOR';
    }
  }

  getSubjects(
      {required String semesterID,
      required String level,
      required String strand_id}) async {
    log("semester id $semesterID");
    log("level  $level");
    log(" strand id $strand_id");
    subjectList.clear();
    var res = await FirebaseFirestore.instance
        .collection('subjects')
        .where('level', isEqualTo: level)
        .where('semester_id', isEqualTo: semesterID)
        .where('strand_id', isEqualTo: strand_id)
        .get();
    var subjecs = res.docs;
    List tempSub = [];
    for (var i = 0; i < subjecs.length; i++) {
      Map mapData = subjecs[i].data();
      mapData['isSelected'] = false;
      tempSub.add(mapData);
    }
    setState(() {
      subjectList = tempSub;
      log(subjectList.length.toString());
    });
    for (var i = 0; i < widget.instructorData.subject!.length; i++) {
      for (var x = 0; x < subjectList.length; x++) {
        if (widget.instructorData.subject![i].id == subjectList[x]['id']) {
          subjectList[x]['isSelected'] = true;
        }
      }
    }
  }

  bool isLoaded = false;
  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() async {
    await getStrands();
    await getSections();
    await getSemester();
    await getGrade();
    getSubjects(
        semesterID: selectedSemesterID,
        level: selectedLevel,
        strand_id: selectedStrandID);
    AdminDB.username.text = widget.instructorData.username;
    AdminDB.firstName.text = widget.instructorData.firstName;
    AdminDB.lastName.text = widget.instructorData.lastName;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AdminDB adminDB = Provider.of<AdminDB>(context);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       adminDB.clearInstructorForm();
      //       context.popRoute();
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: AdminNavigationBar(
          child: GestureDetector(
            onTap: () {
              setState(() {});
            },
            child: Form(
              key: AdminDB.addInstructorFormKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Add Instructor",
                        style: theme.textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      Divider(
                        color: Colors.black,
                      ),
                      SecondaryTextField(
                        fieldKey: AdminDB.usernameKey,
                        controller: AdminDB.username,
                        readOnly: true,
                        label: "Username",
                        hintText: "Username",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z0-9]')),
                        ],
                        validator: Commons.forcedTextValidator,
                      ),
                      const SizedBox(height: 5.0),
                      SecondaryTextField(
                        fieldKey: AdminDB.firstNameKey,
                        controller: AdminDB.firstName,
                        label: "First Name",
                        hintText: "First Name",
                        validator: Commons.forcedTextValidator,
                      ),
                      const SizedBox(height: 5.0),
                      SecondaryTextField(
                        fieldKey: AdminDB.lastNameKey,
                        controller: AdminDB.lastName,
                        label: "Last Name",
                        hintText: "Last Name",
                        validator: Commons.forcedTextValidator,
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "Please choose a grade for the instructor",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(gradeList.length, (index) {
                          return PrimaryButton(
                            onPressed: () {
                              // adminDB.updateGradeInstructor(
                              //     adminDB.gradeList[index]);
                              if (gradeList[index]['id'] == "4" ||
                                  gradeList[index]['id'] == "5") {
                                selectedLevel = "SENIOR";
                              } else {
                                selectedLevel = "JUNIOR";
                              }
                              setState(() {
                                selectedGrade = {
                                  "id": gradeList[index]['id'].toString(),
                                  "label": gradeList[index]['label'],
                                };
                                selectedGradeID =
                                    gradeList[index]['id'].toString();
                              });
                              getSubjects(
                                  semesterID: selectedSemesterID,
                                  level: selectedLevel,
                                  strand_id: selectedStrandID);
                            },
                            color: selectedGradeID == gradeList[index]['id']
                                ? Colors.white
                                : Colors.black87,
                            backgroundColor:
                                selectedGradeID == gradeList[index]['id']
                                    ? Colors.black87
                                    : Colors.white,
                            label: gradeList[index]['label'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        "Please choose a section for the instructor",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: List.generate(sectionList.length, (index) {
                          return PrimaryButton(
                            onPressed: () {
                              // adminDB
                              //     .updateInstructorSection(sectionList[index]);
                              setState(() {
                                selectedSectionID =
                                    sectionList[index]['id'].toString();
                                selectedSectionMap = sectionList[index];
                                selectedSection = {
                                  "id": sectionList[index]['id'],
                                  "label": sectionList[index]['label']
                                };
                              });
                            },
                            color: selectedSectionID ==
                                    sectionList[index]['id'].toString()
                                ? Colors.white
                                : Colors.black87,
                            backgroundColor: selectedSectionID ==
                                    sectionList[index]['id'].toString()
                                ? Colors.black87
                                : Colors.white,
                            label: sectionList[index]['label'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24.0),
                      Visibility(
                        visible:
                            selectedGradeID == "4" || selectedGradeID == "5",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please choose a semester for the instructor",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children:
                                  List.generate(semesterList.length, (index) {
                                return PrimaryButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedSemesterID = semesterList[index]
                                                ['id']
                                            .toString();
                                        selectedSemesterMap =
                                            semesterList[index];
                                      });
                                      getSubjects(
                                          semesterID: selectedSemesterID,
                                          level: selectedLevel,
                                          strand_id: selectedStrandID);

                                      // adminDB.updateSemesterInstructorOption(
                                      //     adminDB.semesterList[index]);
                                    },
                                    color: selectedSemesterID ==
                                            semesterList[index]['id'].toString()
                                        ? Colors.white
                                        : Colors.black87,
                                    backgroundColor: selectedSemesterID ==
                                            semesterList[index]['id'].toString()
                                        ? Colors.black87
                                        : Colors.white,
                                    label:
                                        semesterList[index]['name'].toString());
                              }).toList(),
                            ),
                            const SizedBox(height: 24.0),
                            Text(
                              "Please choose a strand for the instructor",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Wrap(
                              spacing: 10.0,
                              runSpacing: 10.0,
                              children:
                                  List.generate(strandList.length, (index) {
                                return PrimaryButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedStrandID =
                                          strandList[index]['id'].toString();
                                      selectedStrandMap = strandList[index];
                                    });
                                    getSubjects(
                                        semesterID: selectedSemesterID,
                                        level: selectedLevel,
                                        strand_id: selectedStrandID);
                                  },
                                  color: selectedStrandID ==
                                          strandList[index]['id'].toString()
                                      ? Colors.white
                                      : Colors.black87,
                                  backgroundColor: selectedStrandID ==
                                          strandList[index]['id'].toString()
                                      ? Colors.black87
                                      : Colors.white,
                                  label:
                                      strandList[index]['acronym'].toString(),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: subjectList.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 24.0),
                            Text(
                              "Please choose a subject/s for the instructor",
                              style: theme.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              child: Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children:
                                    List.generate(subjectList.length, (index) {
                                  return PrimaryButton(
                                    onPressed: () {
                                      setState(() {
                                        if (subjectList[index]['isSelected'] ==
                                            true) {
                                          subjectList[index]['isSelected'] =
                                              false;
                                        } else {
                                          subjectList[index]['isSelected'] =
                                              true;
                                        }
                                      });
                                    },
                                    color:
                                        subjectList[index]['isSelected'] == true
                                            ? Colors.white
                                            : Colors.black87,
                                    backgroundColor:
                                        subjectList[index]['isSelected'] == true
                                            ? Colors.black87
                                            : Colors.white,
                                    label: subjectList[index]['name'],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              onPressed: () {
                                adminDB.clearInstructorForm();
                                context.popRoute();
                              },
                              color: Colors.black87,
                              backgroundColor: Colors.white,
                              label: "Cancel",
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: PrimaryButton(
                              onPressed: (subjectList.isNotEmpty)
                                  ? () {
                                      List subjectsSelected = [];
                                      for (var i = 0;
                                          i < subjectList.length;
                                          i++) {
                                        if (subjectList[i]['isSelected'] ==
                                            true) {
                                          subjectsSelected.add(subjectList[i]);
                                        }
                                      }
                                      adminDB
                                          .editNewInstructor(
                                              context,
                                              subjectsSelected,
                                              selectedGrade,
                                              selectedSection,
                                              selectedStrandMap,
                                              widget
                                                  .instructorData.userModel.id)
                                          .then((value) {
                                        // scaffoldKey.currentContext!.popRoute();
                                      });
                                    }
                                  : null,
                              label: "Save",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
