import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/Day6/Payment.dart';
import '/firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Center(child: Text('ProductView 테스트')),
    ),
  ));
}

class ProductView extends StatefulWidget {
  final String docId;
  const ProductView({super.key, required this.docId});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  Map<String, dynamic>? product; // null 허용

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future<void> getProduct() async {
    try {
      final snap = await fs.collection("product").doc(widget.docId).get();
      if (snap.exists) {
        setState(() {
          product = snap.data();
        });
      } else {
        print("문서가 존재하지 않습니다.");
      }
    } catch (e) {
      print("제품 가져오기 실패: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('제품 상세보기')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('제품 상세보기')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('제품명: ${product!['pName']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('카테고리: ${product!['category']}'),
            SizedBox(height: 8),
            Text('가격: ₩ ${product!['price']}'),
            SizedBox(height: 8),
            Text('설명: ${product!['info']}'),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Payment(
                            pName: product!['pName'],
                            price: product!['price'],
                          )
                      )
                  );
                },
                child: Text("구매하기")
            )
          ],
        ),
      ),
    );
  }
}
