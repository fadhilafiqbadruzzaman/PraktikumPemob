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
      title: 'Kartu Perkenalan',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
          title: const Text('Kartu Perkenalan'),
          centerTitle: true,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.pinkAccent,
              ),

              SizedBox(height: 20),

              Text(
                'Fadhil Afiq Badruzzaman',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 10),

              Text(
                'NIM: 2024080119',
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 10),

              Text(
                'Jurusan: Teknik Informatika',
                style: TextStyle(fontSize: 18),
              ),

              SizedBox(height: 10),

              Icon(
                Icons.music_note,
                size: 100,
                color: Colors.pinkAccent,
              ),

              SizedBox(height: 5),

              Text(
                'Hobi: MUSIK',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}