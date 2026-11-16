
import 'package:flutter/material.dart';

import '../app_constants.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import '../services/profile_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final ProfileService profileService = ProfileService();

  UserProfile? userProfile;
  bool isProfileLoading = true;

  final nameController = TextEditingController(text: studentName);
  final nimController = TextEditingController(text: studentId);
  final commentController = TextEditingController();

  String submittedName = '';
  String submittedNim = '';
  String submittedComment = '';

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await profileService.getMyProfile();

      if (!mounted) return;

      setState(() {
        userProfile = profile;
        isProfileLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isProfileLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil profil: $error'),
        ),
      );
    }
  }

  Widget _buildProfileCard() {
    if (isProfileLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (userProfile == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Data profil belum tersedia.',
          ),
        ),
      );
    }

    final profile = userProfile!;

    String roleLabel;

    switch (profile.role) {
      case 'student':
        roleLabel = 'Mahasiswa';
        break;
      case 'lecturer':
        roleLabel = 'Dosen';
        break;
      case 'admin':
        roleLabel = 'Administrator';
        break;
      default:
        roleLabel = profile.role;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Akun',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 24),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('Nama Lengkap'),
              subtitle: Text(
                profile.fullName.isEmpty
                    ? 'Belum diisi'
                    : profile.fullName,
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              subtitle: Text(profile.email),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.badge_outlined),
              title: const Text('Role'),
              subtitle: Text(roleLabel),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitFeedback() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final nim = nimController.text.trim();
    final comment = commentController.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Apakah kamu yakin ingin mengirim feedback?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
      submittedName = name;
      submittedNim = nim;
      submittedComment = comment;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data berhasil disimpan'),
      ),
    );
  }

  // Logout pengguna
  Future<void> _logout() async {
    try {
      await AuthService().logout();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berhasil logout'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tombol logout
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informasi profil Supabase
            _buildProfileCard(),

            const SizedBox(height: 24),

            // Form feedback
            const Text(
              'Form Feedback',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: nimController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                hintText: 'Minimal 5 karakter',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().length < 5) {
                  return 'Komentar minimal 5 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : submitFeedback,
              child: isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text('Kirim Feedback'),
            ),

            // Menampilkan hasil feedback
            if (submittedComment.isNotEmpty) ...[
              const SizedBox(height: 24),

              const Text(
                'Feedback berhasil divalidasi:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text('Nama: $submittedName'),
              Text('NIM: $submittedNim'),
              Text('Komentar: $submittedComment'),
            ],
          ],
        ),
      ),
    );
  }
}
