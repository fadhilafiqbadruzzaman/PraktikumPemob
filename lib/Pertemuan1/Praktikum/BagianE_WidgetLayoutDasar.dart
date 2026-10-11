import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Praktikum 1',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profil Saya'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flutter_dash,
                size: 80,
                color: Colors.blue,
              ),

              SizedBox(height: 16),

              Text(
                'Halo, nama saya Fadhil Afiq Badruzzaman!',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),

              Text(
                'NIM: 2010010476',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}