import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class SubjectsPage extends StatefulWidget {
  const SubjectsPage({super.key});

  @override
  State<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<String> js = ["JUNIOR", "SENIOR"];
  String jsSelected = "JUNIOR";
  String jsSelectedAddSubject = "JUNIOR";
  Map selectedStrand = {};
  String selectedStrandID = "";
  Map selectedSemester = {};
  String selectedSemesterID = "";

  List subjectList = [];
  List strandsList = [];
  List semesterList = [];

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  getSubjects() async {
    var res = await FirebaseFirestore.instance
        .collection('subjects')
        .where('level', isEqualTo: jsSelected)
        .get();
    var subjects = res.docs;
    List tempData = [];
    for (var i = 0; i < subjects.length; i++) {
      Map data = subjects[i].data();
      tempData.add(data);
    }

    setState(() {
      subjectList = tempData;
    });
  }

  getSemesters() async {
    var res = await FirebaseFirestore.instance.collection('semester').get();
    var data = res.docs;
    List tempdata = [];
    for (var i = 0; i < data.length; i++) {
      Map mapdata = data[i].data();
      mapdata['id'] = data[i].id;
      tempdata.add(mapdata);
    }
    semesterList = tempdata;
    if (semesterList.isNotEmpty) {
      selectedSemester = semesterList[0];
    }
  }

  getStrands() async {
    var res = await FirebaseFirestore.instance.collection('strand').get();
    var data = res.docs;
    List tempdata = [];
    for (var i = 0; i < data.length; i++) {
      Map mapdata = data[i].data();
      mapdata['id'] = data[i].id;
      tempdata.add(mapdata);
    }
    strandsList = tempdata;
    if (strandsList.isNotEmpty) {
      selectedStrand = strandsList[0];
    }
  }

  insertSubject({
    required String name,
    required String unit,
  }) async {
    try {
      if (jsSelectedAddSubject == 'JUNIOR') {
        var docID =
            await FirebaseFirestore.instance.collection('subjects').doc();
        await FirebaseFirestore.instance
            .collection('subjects')
            .doc(docID.id)
            .set({
          "grades": [
            {"grade": 0, "title": "First"},
            {"grade": 0, "title": "Second"},
            {"grade": 0, "title": "Third"},
            {"grade": 0, "title": "Fourth"}
          ],
          "id": docID.id,
          "isActive": true,
          "level": 'JUNIOR',
          "name": name,
          "schedule": [],
          "semester": "",
          "semester_id": "",
          "strand": "",
          "strand_id": "",
          "units": unit
        });
      } else {
        var docID =
            await FirebaseFirestore.instance.collection('subjects').doc();
        await FirebaseFirestore.instance
            .collection('subjects')
            .doc(docID.id)
            .set({
          "grades": [
            {"grade": 0, "title": selectedSemester['name']},
          ],
          "id": docID.id,
          "isActive": true,
          "level": 'SENIOR',
          "name": name,
          "schedule": [],
          "semester": selectedSemester['name'],
          "semester_id": selectedSemester['id'],
          "strand": selectedStrand['acronym'],
          "strand_id": selectedStrand['id'],
          "units": unit
        });
      }
      Navigator.pop(context);
      await getSubjects();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Success'),
      ));
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Error'),
      ));
    }
  }

  // populateSubjects() async {
  //   var res = await FirebaseFirestore.instance
  //       .collection('stemSecondSubjectList')
  //       .get();
  //   var data = res.docs;
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   for (var i = 0; i < data.length; i++) {
  //     DocumentReference docRef =
  //         FirebaseFirestore.instance.collection('subjects').doc();
  //     Map datamap = data[i].data();
  //     datamap['level'] = 'SENIOR';
  //     datamap['strand'] = 'STEM';
  //     datamap['strand_id'] = 'vnGPlz44ASsHi65nzJU0';
  //     // datamap['semester'] = 'First';
  //     // datamap['semester_id'] = 'yf8hdtk92umDPByQFiO0';
  //     datamap['semester'] = 'Second';
  //     datamap['semester_id'] = 'aaF6v3i1IzeJSbreJOO7';
  //     datamap['isActive'] = true;
  //     datamap['id'] = docRef.id;
  //     batch.set(docRef, datamap);
  //   }
  //   await batch.commit();
  // }

  @override
  void initState() {
    getSubjects();
    getStrands();
    getSemesters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subjects",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        width: MediaQuery.of(context).size.width * 0.14,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12)),
                        child: DropdownButton<String>(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          value: jsSelected,
                          elevation: 16,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              jsSelected = value!;
                            });
                            getSubjects();
                          },
                          items:
                              js.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        width: getWidth(3),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                            const Color.fromARGB(255, 161, 20, 10),
                          )),
                          onPressed: () {
                            addSubject();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(
                                  width: getWidth(1),
                                ),
                                Text("Add subject")
                              ],
                            ),
                          ))
                    ],
                  )
                ],
              ),
              SizedBox(
                height: getHeight(2),
              ),
              Container(
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjectList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: getHeight(2)),
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 161, 20, 10),
                          title: Text(
                            subjectList[index]['name'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            subjectList[index]['strand'] == ""
                                ? "Grade 7 - 10"
                                : subjectList[index]['strand'] +
                                    " - " +
                                    subjectList[index]['semester'] +
                                    " semester",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  addSubject() async {
    TextEditingController name = TextEditingController();
    TextEditingController units = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                color: Colors.white,
                height: getHeight(70),
                width: getWidth(40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add Subject",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.14,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton<String>(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.02),
                            value: jsSelectedAddSubject,
                            elevation: 16,
                            isExpanded: true,
                            underline: SizedBox(),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                jsSelectedAddSubject = value!;
                              });
                            },
                            items: js
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: getHeight(3),
                    ),
                    Text("Name"),
                    Container(
                      height: getHeight(8),
                      width: getWidth(80),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: getWidth(1)),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: getHeight(2),
                    ),
                    Text("Units"),
                    Container(
                      height: getHeight(8),
                      width: getWidth(80),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: units,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: getWidth(1)),
                            border: InputBorder.none),
                      ),
                    ),
                    jsSelectedAddSubject == "SENIOR"
                        ? SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: getHeight(2),
                                ),
                                Text("Semester"),
                                Container(
                                  height: getHeight(8),
                                  width: getWidth(80),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: DropdownButton<dynamic>(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    value: selectedSemester,
                                    elevation: 16,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    onChanged: (dynamic value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        selectedSemester = value;
                                        selectedSemesterID = value!['id'];
                                      });
                                    },
                                    items: semesterList
                                        .map<DropdownMenuItem<dynamic>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Text(
                                          value['name'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeight(2),
                                ),
                                Text("Strand"),
                                Container(
                                  height: getHeight(8),
                                  width: getWidth(80),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: DropdownButton<dynamic>(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.01),
                                    value: selectedStrand,
                                    elevation: 16,
                                    isExpanded: true,
                                    underline: SizedBox(),
                                    onChanged: (dynamic value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        selectedStrand = value;
                                        selectedStrandID = value!['id'];
                                      });
                                    },
                                    items: strandsList
                                        .map<DropdownMenuItem<dynamic>>(
                                            (dynamic value) {
                                      return DropdownMenuItem<dynamic>(
                                        value: value,
                                        child: Text(
                                          value['acronym'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    Expanded(child: SizedBox()),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                          const Color.fromARGB(255, 161, 20, 10),
                        )),
                        onPressed: () {
                          insertSubject(name: name.text, unit: units.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              SizedBox(
                                width: getWidth(1),
                              ),
                              Text("Add")
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            );
          });
        });
  }
}
