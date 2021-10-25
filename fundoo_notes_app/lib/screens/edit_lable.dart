import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Edit_Lable extends StatefulWidget {
  Edit_Lable({Key? key}) : super(key: key);

  @override
  _Edit_LableState createState() => _Edit_LableState();
}

class _Edit_LableState extends State<Edit_Lable> {
  List allLable = [];
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
    // searchLable = allLable;
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
        title: Text(
          'Edit labels',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.add, color: Colors.black),
                SizedBox(width: 20),
                Text(
                  "Create new lable",
                  style: TextStyle(fontSize: 18, color: Colors.black26),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                //  physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                itemCount: allLable.length,
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
                          allLable[index]['lable'],
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //new Spacer(),
                              Icon(Icons.edit)
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
