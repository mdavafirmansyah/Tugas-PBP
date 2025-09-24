import 'package:flutter/material.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String title, required String email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  @override
  void initState() {
    super.initState();
    // Delay 3 detik sebelum pindah ke LoginPage
  //  Future.delayed(const Duration(seconds: 3), () {
    //  Navigator.pushReplacement(
      //  context,
        //MaterialPageRoute(builder: (context) => const LoginPage()),
   //   );
  //  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List Donghua ')), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children : [
            Image.asset(
              'assets/images/login_ui.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
             'Home Screen c',
           
            ),
           
          ],
        ),
      ),
    );
  }
}
