
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String studentName = 'I Gusti Ayu Agung Gita Udiani';
const String studentId = '2415051010';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(),
  ));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;
  late Future<Map<String, dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = loadData();
  }

  Future<Map<String, dynamic>> loadData() async {
    final jsonString =
    await rootBundle.loadString('assets/data/student_data.json');

    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school),
          label: 'Courses',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      CoursesPage(dataFuture: dataFuture),
      const ProfilePage(),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer'),
            ),
            body: pages[selectedIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
          ),
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(
                child: pages[selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}

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
            Icon(Icons.home, size: 70),
            SizedBox(height: 16),
            Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(studentName),
            Text('NIM: $studentId'),
          ],
        ),
      ),
    );
  }
}


class CoursesPage extends StatelessWidget {
  final Future<Map<String, dynamic>> dataFuture;

  const CoursesPage({
    super.key,
    required this.dataFuture,
  });

  Widget buildCourseItem(
      BuildContext context,
      dynamic item,
      ) {
    final course = Map<String, dynamic>.from(item);

    return CourseCard(
      course: course,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailPage(
              course: course,
            ),
          ),
        );
      },
      onLongPress: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mata kuliah: ${course['title']}'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Gagal memuat data'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final courses = snapshot.data!['courses'] as List<dynamic>;

        return LayoutBuilder(
          builder: (context, constraints) {
            final isExpanded = constraints.maxWidth >= 840;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'Daftar Mata Kuliah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: isExpanded
                      ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 4,
                      childAspectRatio: 2.8,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return buildCourseItem(
                        context,
                        courses[index],
                      );
                    },
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return buildCourseItem(
                        context,
                        courses[index],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.book, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course['title'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Kode: ${widget.course['code']}'),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Favorite',
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Ditambahkan ke favorit'
                            : 'Dihapus dari favorit',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '$studentName\nNIM: $studentId',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 32),
            Text(
              course['title'].toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text('Kode: ${course['code']}'),
            Text('SKS: ${course['credits']}'),
            Text('Status: ${course['status']}'),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final nameController = TextEditingController(
    text: studentName,
  );

  final nimController = TextEditingController(
    text: studentId,
  );

  final commentController = TextEditingController();

  String submittedName = '';
  String submittedNim = '';
  String submittedComment = '';

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
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

    if (!mounted) {
      return;
    }
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
