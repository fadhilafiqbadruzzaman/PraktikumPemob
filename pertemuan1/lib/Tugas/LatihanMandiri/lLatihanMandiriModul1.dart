import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  void tambah() {
    setState(() {
      _count++;
    });
  }

  void kurang() {
    if (_count > 0) {
      setState(() {
        _count--;
      });
    }
  }

  void reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Counter Saya',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Jumlah Counter',
              style: TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '$_count',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'kurang',
                  onPressed: kurang,
                  child: const Icon(Icons.remove),
                ),

                const SizedBox(width: 20),

                FloatingActionButton(
                  heroTag: 'reset',
                  onPressed: reset,
                  child: const Icon(Icons.refresh),
                ),

                const SizedBox(width: 20),

                FloatingActionButton(
                  heroTag: 'tambah',
                  onPressed: tambah,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}