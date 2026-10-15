import 'package:flutter/material.dart';
import '../app_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home,size: 70),
            SizedBox(height: 16),
            Text('Selamat Datang!',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(studentName),
            Text('NIM: $studentId'),
          ],
        ),
      ),
    );
  }
}
