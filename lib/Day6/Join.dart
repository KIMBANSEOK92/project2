import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project2/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController pwdCheckController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String gender = 'M';

  // 아이디 중복 체크 여부
  bool isIdChecked = false;

  // 비밀번호 일치 여부
  bool isPasswordMatched = false;

  // member 컬렉션
  final CollectionReference memberRef =
  FirebaseFirestore.instance.collection('member');

  // 스낵바 함수
  void showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // 아이디 중복 체크
  Future<void> checkId() async {
    if (idController.text.isEmpty) {
      showSnack('아이디를 입력하세요');
      return;
    }

    final result = await memberRef
        .where('memberId', isEqualTo: idController.text)
        .get();

    if (result.docs.isEmpty) {
      setState(() {
        isIdChecked = true;
      });
      showSnack('사용 가능한 아이디입니다');
    } else {
      setState(() {
        isIdChecked = false;
      });
      showSnack('이미 사용 중인 아이디입니다');
    }
  }

  // 회원가입 처리
  Future<void> join() async {
    if (idController.text.isEmpty ||
        pwdController.text.isEmpty ||
        pwdCheckController.text.isEmpty ||
        nameController.text.isEmpty) {
      showSnack('모든 항목을 입력하세요');
      return;
    }

    if (!isIdChecked) {
      showSnack('아이디 중복 체크를 해주세요');
      return;
    }

    if (!isPasswordMatched) {
      showSnack('비밀번호가 일치하지 않습니다');
      return;
    }

    await memberRef.add({
      'memberId': idController.text,
      'pwd': pwdController.text,
      'name': nameController.text,
      'gender': gender,
    });

    showSnack('회원가입 성공');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),

                // 아이디, 중복체크
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: '아이디',
                          hintText: '아이디를 입력하세요',
                          prefixIcon: Icon(Icons.person_outline),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (_) {
                          setState(() {
                            isIdChecked = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: checkId,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        child: Text('중복체크'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // 비밀번호
                TextField(
                  controller: pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    hintText: '비밀번호를 입력하세요',
                    prefixIcon: Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) {
                    setState(() {
                      isPasswordMatched =
                          pwdController.text == pwdCheckController.text;
                    });
                  },
                ),
                SizedBox(height: 16),

                // 비밀번호 확인
                TextField(
                  controller: pwdCheckController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    hintText: '비밀번호를 다시 입력하세요',
                    prefixIcon: Icon(Icons.lock_reset_outlined),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (_) {
                    setState(() {
                      isPasswordMatched =
                          pwdController.text == pwdCheckController.text;
                    });
                  },
                ),
                SizedBox(height: 16),

                // 이름
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintText: '홍길동',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // 성별
                Text(
                  '성별',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text('남자'),
                        value: 'M',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text('여자'),
                        value: 'F',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value!;
                          });
                        },
                        dense: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // 회원가입 버튼 (아이디 중복 체크 + 비밀번호 일치 시 활성화)
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed:
                    (isIdChecked && isPasswordMatched) ? join : null, // 변경
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
