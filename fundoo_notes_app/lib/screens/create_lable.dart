import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Create_Lable extends StatefulWidget {
  Create_Lable({Key? key}) : super(key: key);

  @override
  _Create_LableState createState() => _Create_LableState();
}

class _Create_LableState extends State<Create_Lable> {
  String lableName = "";
  List allLable = [];
  List searchLable = [];
  bool checkboxValue = false;

  TextEditingController createLable = new TextEditingController();

  Future<void> getLables() async {
    Query collectionReference = FirebaseFirestore.instance.collection('lable');
    QuerySnapshot querySnapshot = await collectionReference.get();
    final allLables = querySnapshot.docs.map((data) => data.data()).toList();
    print('sssssssssssssssssssssssssssssssssssssssssssssssssssss');
    print(allLables);
    querySnapshot.docs.forEach((allLables) {
      var map = {'lable': allLables['lable']};
      setState(() {
        allLable.add(map);
      });
    });
    print('...........');
    print(allLable);
    searchLable = allLable;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          foregroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              icon: Icon(Icons.arrow_back)),
          title: TextField(
            autofocus: true,
            controller: createLable,
            style: TextStyle(fontSize: 18),
            decoration: new InputDecoration(
              hintText: 'Enter lable name',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onChanged: (value) {
              if (value != "") {
                print(value);
                setState(() {
                  lableName = value;
                  searchLable = allLable
                      .where((allLable) => allLable['lable']
                          .toString()
                          .
                          // toLowerCase().
                          contains(value))
                      .toList();
                });
              } else {
                setState(() {
                  lableName = "";
                  searchLable = allLable;
                });
              }
            },
          ),
          // bottom: PreferredSize(
          //     child: Container(
          //       color: Colors.black,
          //       height: 1.0,
          //     ),
          //     preferredSize: Size.fromHeight(1.0)),
        ),
        body: Column(
          children: [
            if (lableName != "")
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Create $lableName",
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  print(',,,,,,,,,,,,,,');
                  if (lableName != "") {
                    Map<String, dynamic> lable = {
                      "lable": lableName,
                    };
                    FirebaseFirestore.instance.collection("lable").add(lable);
                    // getLables();

                    var map = {'lable': lableName};
                    setState(() {
                      allLable.add(map);
                      searchLable = allLable;
                      lableName = "";
                      createLable.text = "";
                    });
                  }
                },
              ),
            Expanded(
              child: ListView.builder(
                  //  physics: NeverScrollableScrollPhysics(),
                  // shrinkWrap: true,
                  itemCount: searchLable.length,
                  itemBuilder: (BuildContext context, int index) {
                    // var value;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.label_outline),
                          SizedBox(width: 30),
                          Text(
                            searchLable[index]['lable'],
                            style: TextStyle(fontSize: 20),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              //crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //new Spacer(),
                                Checkbox(
                                  value: this.checkboxValue,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      this.checkboxValue = value!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
