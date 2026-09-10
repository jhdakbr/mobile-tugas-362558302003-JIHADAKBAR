import 'package:flutter/material.dart';
import 'models/course.dart';
import 'widgets/course_card.dart';
import 'widgets/header_banner.dart';

class AcademicDashboardScreen extends StatefulWidget {
  const AcademicDashboardScreen({super.key});

  @override
  State<AcademicDashboardScreen> createState() =>
      _AcademicDashboardScreenState();
}

class _AcademicDashboardScreenState
    extends State<AcademicDashboardScreen> {
  final List<Course> _courses = Course.getSampleCourses();

  bool _isDarkMode = false;
  String _selectedCategory = 'Semua';

  final List<String> _categories = const [
    'Semua',
    'Pemrograman',
    'Arsitektur',
    'Manajemen',
    'QA',
  ];

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  List<Course> get _filteredCourses {
    if (_selectedCategory == 'Semua') {
      return _courses;
    }

    return _courses
        .where((course) => course.category == _selectedCategory)
        .toList();
  }

  int get _totalSks {
    return _courses.fold(
      0,
      (total, course) => total + course.sks,
    );
  }

  Widget _buildCategoryFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter Kategori',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            return ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSksWarning() {
    if (_totalSks <= 24) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          Icons.warning_amber_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
        title: const Text(
          'Beban SKS melebihi batas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Total $_totalSks SKS. Batas yang direkomendasikan adalah 24 SKS.',
        ),
      ),
    );
  }

  Widget _buildCourseList() {
    final courses = _filteredCourses;

    if (courses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Tidak ada mata kuliah pada kategori ini.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: courses
          .map(
            (course) => CourseCard(course: course),
          )
          .toList(),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const HeaderBanner(),
        const SizedBox(height: 16),
        _buildSksWarning(),
        _buildCategoryFilter(),
        const SizedBox(height: 16),
        Text(
          'Mata Kuliah Semester 3 (${_filteredCourses.length} Terdaftar)',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildCourseList(),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderBanner(),
          const SizedBox(height: 20),
          _buildSksWarning(),
          _buildCategoryFilter(),
          const SizedBox(height: 20),
          Text(
            'Mata Kuliah Semester 3 (${_filteredCourses.length} Terdaftar)',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 340,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 240,
            ),
            itemCount: _filteredCourses.length,
            itemBuilder: (context, index) {
              return CourseCard(
                course: _filteredCourses[index],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: HeaderBanner(),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSksWarning(),
                  _buildCategoryFilter(),
                  const SizedBox(height: 20),
                  Text(
                    'Mata Kuliah Semester 3 '
                    '(${_filteredCourses.length} Terdaftar)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 340,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 240,
                    ),
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(
                        course: _filteredCourses[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0284C7),
          brightness: _isDarkMode
              ? Brightness.dark
              : Brightness.light,
        ),
        useMaterial3: true,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Akademik TRPL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF0284C7),
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(
                _isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
              ),
              tooltip: _isDarkMode
                  ? 'Mode Terang'
                  : 'Mode Gelap',
              onPressed: _toggleDarkMode,
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1024) {
              return _buildDesktopLayout();
            }

            if (constraints.maxWidth >= 600) {
              return _buildTabletLayout();
            }

            return _buildMobileLayout();
          },
        ),
      ),
    );
  }
}
