import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseEditPage extends StatefulWidget {
  final Course course;
  const CourseEditPage({
    super.key,
    required this.course,
  });
  @override
  State<CourseEditPage> createState() => _CourseEditPageState();
}
class _CourseEditPageState extends State<CourseEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleController;
  late final TextEditingController _creditsController;
  late String _status;
  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(
      text: widget.course.code,
    );
    _titleController = TextEditingController(
      text: widget.course.title,
    );
    _creditsController = TextEditingController(
      text: widget.course.credits.toString(),
    );
    _status = widget.course.status;
  }
  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }
  Future<void> _updateCourse() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<CourseProvider>();
    final updatedCourse = Course(
      id: widget.course.id,
      code: widget.course.code,
      title: _titleController.text.trim(),
      credits: int.parse(_creditsController.text.trim()),
      status: _status,
    );
    final success = await provider.updateCourse(
      widget.course.id ?? -1,
      updatedCourse,
    );
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mata kuliah berhasil diperbarui.'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal memperbarui mata kuliah. Coba lagi.',
          ),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Mata Kuliah'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              '2415051010_I Gusti Ayu Agung Gita Udiani',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _codeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Kode Mata Kuliah',
                border: OutlineInputBorder(),
                helperText: 'Kode tidak dapat diubah.',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Mata Kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama mata kuliah wajib diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _creditsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah SKS',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Jumlah SKS wajib diisi';
                }
                final credits = int.tryParse(value.trim());
                if (credits == null || credits <= 0) {
                  return 'SKS harus berupa angka positif';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'planned',
                  child: Text('Planned'),
                ),
                DropdownMenuItem(
                  value: 'active',
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'done',
                  child: Text('Done'),
                ),
              ],
              onChanged: isSaving
                  ? null
                  : (value) {
                if (value != null) {
                  setState(() => _status = value);
                }
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: isSaving ? null : _updateCourse,
              icon: isSaving
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Icon(Icons.save),
              label: Text(
                isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
