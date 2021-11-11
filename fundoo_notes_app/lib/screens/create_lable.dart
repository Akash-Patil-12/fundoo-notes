import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Create_Lable extends StatefulWidget {
  Create_Lable({Key? key}) : super(key: key);

  @override
  _Create_LableState createState() => _Create_LableState();
}

class _Create_LableState extends State<Create_Lable> {
  String lableName = "";
  List allLable = [];
  List searchLable = [];
  List<String> selectedLable = [];
  List<String> selectedLables = [];
  TextEditingController createLable = new TextEditingController();

  Future<void> getLables() async {
    final prefs = await SharedPreferences.getInstance();

    // if (prefs.containsKey('selectedLables') == true &&
    //     prefs.getStringList('selectedLables') != null) {
    //   selectedLables = prefs.getStringList('selectedLables')!.cast<String>();
    //   selectedLable = selectedLables;
    // }
    // if (prefs.containsKey('updateLable') == true &&
    //     prefs.getStringList('updateLable') != null) {
    //   selectedLables = prefs.getStringList('updateLable')!.cast<String>();
    //   selectedLable = selectedLables;
    // }
    Query collectionReference = FirebaseFirestore.instance.collection('lable');
    QuerySnapshot querySnapshot = await collectionReference.get();
    final allLables = querySnapshot.docs.map((data) => data.data()).toList();
    print('sssssssssssssssssssssssssssssssssssssssssssssssssssss');
    print(allLables);
    querySnapshot.docs.forEach((allLables) {
      bool setvalue = false;
      if (selectedLables.contains(allLables['lable'])) {
        setvalue = true;
      }
      var map = {'lable': allLables['lable'], 'isCheckedValue': setvalue};
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
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setStringList('selectedLables', selectedLable);

                // if (prefs.containsKey('updateLable') == true &&
                //     prefs.getStringList('updateLable') != null) {
                //   // Navigator.pushNamed(context, '/updateNotes', arguments: {
                //   //   'email': prefs.getString('emailUpdate'),
                //   //   'firstName': prefs.getString('firstNameUpdate'),
                //   //   'color': prefs.getString('colorUpdate'),
                //   //   'note': prefs.getString('noteUpdate'),
                //   //   'title': prefs.getString('titleUpdate'),
                //   //   'pin': prefs.getBool('pinUpdate'),
                //   //   'archived': prefs.getBool('archivedUpdate'),
                //   //   'id': prefs.getString('idUpdate'),
                //   //   'lables': selectedLable,
                //   //   'rootSource': 'home'
                //   // });
                //   print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
                //   print(prefs.getString('firstNameUpdate'));
                // }
                Navigator.pushNamed(context, '/addNotes',
                    arguments: {'selectedLables': selectedLable});

                //  final prefs = await SharedPreferences.getInstance();
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

                    var map = {'lable': lableName, 'isCheckedValue': true};
                    setState(() {
                      selectedLable.add(lableName);
                      print(selectedLable);
                      // searchLable.add(map);
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
                                  value:
                                      // selectedLables
                                      //         .contains(searchLable[index]['lable'])
                                      // ? true
                                      searchLable[index]['isCheckedValue'],
                                  onChanged: (bool? value) {
                                    if (value == true) {
                                      print('.........true');
                                      selectedLable
                                          .add(searchLable[index]['lable']);
                                      print(selectedLable);
                                    } else {
                                      print('.......false');
                                      if (selectedLable.contains(
                                          searchLable[index]['lable'])) {
                                        selectedLable.remove(
                                            searchLable[index]['lable']);
                                        print(selectedLable);
                                      }
                                    }
                                    setState(() {
                                      this.searchLable[index]
                                          ['isCheckedValue'] = value!;
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
