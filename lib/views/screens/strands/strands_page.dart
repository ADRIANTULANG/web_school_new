import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@RoutePage()
class StrandPage extends StatefulWidget {
  const StrandPage({super.key});

  @override
  State<StrandPage> createState() => _StrandPageState();
}

class _StrandPageState extends State<StrandPage> {
  List strandsList = [];

  getStrands() async {
    var res = await FirebaseFirestore.instance.collection('strand').get();
    var data = res.docs;
    List tempdata = [];
    for (var i = 0; i < data.length; i++) {
      Map mapdata = data[i].data();
      mapdata['id'] = data[i].id;
      tempdata.add(mapdata);
    }
    setState(() {
      strandsList = tempdata;
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

  insertStrand({
    required String name,
    required String acronym,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('strand')
          .add({"name": name, "acronym": acronym});
      Navigator.pop(context);
      await getStrands();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text('Success'),
      ));
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    getStrands();
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
                        addStrands();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            SizedBox(
                              width: getWidth(1),
                            ),
                            Text("Add strands")
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
                    itemCount: strandsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(top: getHeight(2)),
                        child: ListTile(
                          tileColor: Color.fromARGB(255, 161, 20, 10),
                          title: Text(
                            strandsList[index]['name'],
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          subtitle: Text(
                            strandsList[index]['acronym'],
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

  addStrands() async {
    TextEditingController name = TextEditingController();
    TextEditingController acronym = TextEditingController();
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
                      "Add Strands",
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
                    SizedBox(
                      height: getHeight(2),
                    ),
                    Text("Acronym"),
                    Container(
                      height: getHeight(8),
                      width: getWidth(80),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: acronym,
                        // keyboardType: TextInputType.number,
                        // inputFormatters: [
                        //   FilteringTextInputFormatter.digitsOnly
                        // ],
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
                          insertStrand(name: name.text, acronym: acronym.text);
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
