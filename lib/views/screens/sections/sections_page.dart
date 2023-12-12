import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@RoutePage()
class SectionsPage extends StatefulWidget {
  const SectionsPage({super.key});

  @override
  State<SectionsPage> createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
  List sectionList = [];

  getSection() async {
    var res = await FirebaseFirestore.instance.collection('sectionList').get();
    var data = res.docs;
    List tempdata = [];
    for (var i = 0; i < data.length; i++) {
      Map mapdata = data[i].data();
      mapdata['id'] = data[i].id.toString();
      tempdata.add(mapdata);
    }
    setState(() {
      sectionList = tempdata;
    });
  }

  getHeight(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.height * toDecimal;
  }

  getWidth(percent) {
    var toDecimal = percent / 100;
    return MediaQuery.of(context).size.width * toDecimal;
  }

  insertSection({
    required String label,
  }) async {
    try {
      var docid =
          await FirebaseFirestore.instance.collection('sectionList').doc();
      await FirebaseFirestore.instance
          .collection('sectionList')
          .doc(docid.id)
          .set({"id": docid.id, "label": label});
      Navigator.pop(context);
      await getSection();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Success'),
      ));
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    getSection();
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
                    "Strands",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                        const Color.fromARGB(255, 161, 20, 10),
                      )),
                      onPressed: () {
                        addSection();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: getWidth(1),
                            ),
                            Text("Add section")
                          ],
                        ),
                      ))
                ],
              ),
              SizedBox(
                height: getHeight(2),
              ),
              Container(
                child: SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sectionList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: getHeight(2)),
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 161, 20, 10),
                          title: Text(
                            sectionList[index]['label'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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

  addSection() async {
    TextEditingController name = TextEditingController();
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
                    Text(
                      "Add Section",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    Expanded(child: SizedBox()),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                          const Color.fromARGB(255, 161, 20, 10),
                        )),
                        onPressed: () {
                          insertSection(
                            label: name.text,
                          );
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
