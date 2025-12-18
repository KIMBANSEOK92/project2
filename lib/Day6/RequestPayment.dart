import 'package:flutter/material.dart';
import 'package:project2/Day6/Payment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  await dotenv.load(fileName : ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReqPayment(),
      // home: Scaffold(),
    );
  }
}

class ReqPayment extends StatefulWidget {
  const ReqPayment({super.key});

  @override
  State<ReqPayment> createState() => _ReqPaymentState();
}

class _ReqPaymentState extends State<ReqPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => Payment()
                      )
                  );
                },
                child: Text("결제하기")
            )
          ],
        ),
      ),
    );
  }
}
