import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _age = TextEditingController();

  // 선택된 사용자 문서 ID (추가)
  String? _selectedDocId;

  // 사용자 추가
  void addUser() async {
    if (_name.text.isNotEmpty && _age.text.isNotEmpty) {
      FirebaseFirestore fs = FirebaseFirestore.instance;
      CollectionReference users = fs.collection("users");

      await users.add({
        'name': _name.text,
        'age': int.parse(_age.text),
      });

      _name.clear();
      _age.clear();
      _selectedDocId = null;
    } else {
      print("이름 또는 나이 입력");
    }
  }

  // 선택된 사용자 수정 (기존 함수 개선)
  void _updateUser() async {
    if (_selectedDocId == null) {
      print("수정할 사용자를 선택하세요");
      return;
    }

    FirebaseFirestore fs = FirebaseFirestore.instance;
    CollectionReference users = fs.collection("users");

    await users.doc(_selectedDocId).update({
      'name': _name.text,
      'age': int.parse(_age.text),
    });

    _name.clear();
    _age.clear();
    _selectedDocId = null;
  }

  // 사용자 목록
  Widget _listUser() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
        if (!snap.hasData) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snap.data!.docs.map((doc) {
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text('나이: ${doc['age']}'),

              // 탭하면 수정 모드 (추가)
              onTap: () {
                setState(() {
                  _name.text = doc['name'];
                  _age.text = doc['age'].toString();
                  _selectedDocId = doc.id;
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Firestore")),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: "이름",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "나이",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),

                // 사용자 추가
                ElevatedButton(
                  onPressed: addUser,
                  child: Text("사용자 추가"),
                ),
                SizedBox(height: 10),

                // 사용자 수정
                ElevatedButton(
                  onPressed: _updateUser,
                  child: Text("사용자 수정"),
                ),

                SizedBox(height: 20),
                Expanded(child: _listUser()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
