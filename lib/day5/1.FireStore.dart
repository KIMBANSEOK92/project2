import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/firebase_options.dart';

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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  // 사용자 삽입
  Future<void> createUser() async {
    await fs.collection("users").doc("document_test").set({
      "name": "홍길동",
      "age": 30,
      "addr": "인천",
      "cdate": Timestamp.now(),
    });
    print("사용자 삽입 완료!");
  }

  // 사용자 목록 조회
  Future<void> readUser() async {
    // final snapshot = await fs.collection("users").orderBy("age", descending: true).get(); // age 기준 오름차순
    final snapshot =
    await fs.collection("users")
        // .where("age", isGreaterThan: 20 ) // age가 20보다 큰 거
        .where("age", isGreaterThanOrEqualTo: 20 ) // age가 20보다 크거나 같을 때
        .orderBy("age")
        .get();
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data();
      print("docId : ${doc.id}, name : ${data["name"]}, age : ${data["age"]}");
    }
  }

  // 사용자 수정
  Future<void> updateUser() async {
    final docRef = fs.collection("users").doc("document_test");
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.update({
        "name": "김철수",
        "age": 25,
      });
      print("사용자 수정 완료!");
    } else {
      print("수정할 문서가 없습니다!");
    }
  }

  // 사용자 삭제
  Future<void> deleteUser() async {
    final docRef = fs.collection("users").doc("document_test");
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      await docRef.delete();
      print("사용자 삭제 완료!");
    } else {
      print("삭제할 문서가 없습니다!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Firestore CRUD 예제")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: createUser, child: const Text("삽입")),
              ElevatedButton(onPressed: readUser, child: const Text("목록")),
              ElevatedButton(onPressed: updateUser, child: const Text("수정")),
              ElevatedButton(onPressed: deleteUser, child: const Text("삭제")),
            ],
          ),
        ),
      ),
    );
  }
}
