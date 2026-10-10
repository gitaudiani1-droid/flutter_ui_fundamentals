import 'package:flutter/material.dart';
const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isCompact = size.width<600;
    return Scaffold(
      appBar: AppBar(title: const Text('Course Explorer')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('$studentId - $studentName'),
              const SizedBox(height: 20),
              const Text('Informasi Layar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$studentId - $studentName'),
                      Text('Width: ${size.width.toStringAsFixed(0)}'),
                      Text('Height: ${size.height.toStringAsFixed(0)}'),
                      Text('Orientasi: $orientation'),
                      Text('Kategori: ${isCompact ? 'Compact' : 'Non-compact'}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
