import 'package:flutter/material.dart';
import 'router.dart';

class Categories extends StatefulWidget {
  final List<String> ranking;

  const Categories({super.key, required this.ranking});

  @override
  State<Categories> createState() => _CategoriesState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}

class _CategoriesState extends State<Categories> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _communityType;
  String? _size;
  String? _learning;
  String? _majors;
  String? _programs;
  String? _housingReq;
  String? _housingType;
  String? _clubs;
  String? _campusType;
  String? _sports;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Criteria')),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),

            child: Column(
              children: [
                // location & environment
                if (widget.ranking.contains("Location & Environment")) ...[
                  Text("Location & Environment"),
                  const SizedBox(height: 5),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Community type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _communityType,
                    items: ['Rural', 'Suburban', 'Urban']
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _communityType = value);
                    },
                  ),
                ],

                // size & reputation
                if (widget.ranking.contains("Size & Reputation")) ...[
                  const SizedBox(height: 20),

                  Text("Size & Reputation"),
                  const SizedBox(height: 5),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Size',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _size,
                    items:
                        [
                              'Small (<5,000)',
                              'Medium (5,000-15,000)',
                              'Big (>15,000)',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _size = value);
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'School Rank (minimum rank)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Graduation rate (minimum rate)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                // cost & financial aid
                if (widget.ranking.contains("Cost & Financial Aid")) ...[
                  const SizedBox(height: 20),

                  Text("Cost & Financial Aid"),

                  const SizedBox(height: 5),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Cost of Attendance (upper cost limit)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],

                // academic fit
                if (widget.ranking.contains("Academic Fit")) ...[
                  const SizedBox(height: 20),
                  Text("Academic Fit"),
                  const SizedBox(height: 5),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Learning System',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _learning,
                    items:
                        [
                              'Problem-based Learning',
                              'Inquiry-based Learning',
                              'Project-based Learning',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _learning = value);
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Majors',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _majors,
                    items:
                        [
                              'Computer Science',
                              'Mechanical Engineering',
                              'Mathematics',
                              'Business',
                              'Biology',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _majors = value);
                    },
                  ),
                ],

                // career opportunities
                if (widget.ranking.contains("Career Opportunities")) ...[
                  const SizedBox(height: 20),

                  Text("Career Opportunities"),

                  const SizedBox(height: 5),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Programs',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _programs,
                    items:
                        [
                              'Co-op Programs',
                              'Research Programs',
                              'Training Programs',
                              'Internships',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _programs = value);
                    },
                  ),
                ],

                // campus life
                if (widget.ranking.contains("Campus Life")) ...[
                  const SizedBox(height: 20),
                  Text("Campus Life"),
                  const SizedBox(height: 5),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Housing Requirement (On-campus)',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _housingReq,
                    items:
                        [
                              'No requirement',
                              'Until 1st year',
                              'Until 2nd year',
                              'Until 3rd year',
                              'All 4 years',
                            ]
                            .map(
                              (option) => DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _housingReq = value);
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Housing Type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _housingType,
                    items: ['Apartment', 'Dorm']
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _housingType = value);
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Clubs',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _clubs,
                    items: ['Arts/Music', 'Community Service', 'Newspaper', 'Honor Society', 'Student Government']
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _clubs = value);
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Campus Type',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _campusType,
                    items: ['Open Campus', 'Closed Campus']
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _campusType = value);
                    },
                  ),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sports',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _sports,
                    items: ['Basketball (Varsity)', 'Badminton (Varsity)', 'Basketball Club', 'Badminton Club', 'Football Club'
                    ]
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _sports = value);
                    },
                  ),

                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
