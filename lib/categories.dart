import 'package:flutter/material.dart';
import 'router.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String kGeoapifyKey = dotenv.env['GEOAPIFY_KEY']?.toString() ?? '';

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

  // 🔹 MULTIPLE locations
  final TextEditingController _locationController = TextEditingController();
  List<String> _locationSuggestions = [];
  List<String> _selectedLocations = []; // store multiple locations
  bool _isSearchingLocation = false;

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  // Call Geoapify autocomplete API
  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearchingLocation = true;
      _locationSuggestions = [];
    });

    final encodedQuery = Uri.encodeComponent(query);
    final url =
        "https://api.geoapify.com/v1/geocode/autocomplete?text=$encodedQuery&format=json&apiKey=$kGeoapifyKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _locationSuggestions = (data["results"] as List)
              .map((r) => r["formatted"] as String)
              .toList();
        });
      } else {
        setState(() {
          _locationSuggestions = [];
        });
      }
    } catch (e) {
      setState(() {
        _locationSuggestions = [];
      });
    }

    if (mounted) {
      setState(() {
        _isSearchingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search by Criteria')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 15),
                  // Add preferred locations (multiple)
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Add preferred city / location',
                      hintText: 'e.g. Providence, RI',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: _isSearchingLocation
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search),
                        onPressed: _isSearchingLocation
                            ? null
                            : () {
                                _searchLocation(_locationController.text);
                              },
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          _locationSuggestions = [];
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  // Suggestions list from Geoapify
                  if (_locationSuggestions.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _locationSuggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _locationSuggestions[index];
                          return ListTile(
                            dense: true,
                            title: Text(
                              suggestion,
                              style: const TextStyle(fontSize: 14),
                            ),
                            onTap: () {
                              setState(() {
                                if (!_selectedLocations.contains(suggestion)) {
                                  _selectedLocations.add(suggestion);
                                }
                                _locationController.clear();
                                _locationSuggestions = [];
                              });
                            },
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 10),

                  // Selected locations as chips
                  if (_selectedLocations.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _selectedLocations.map((loc) {
                        return Chip(
                          label: Text(loc),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              _selectedLocations.remove(loc);
                            });
                          },
                        );
                      }).toList(),
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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Clubs',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _clubs,
                    items:
                        [
                              'Arts/Music',
                              'Community Service',
                              'Newspaper',
                              'Honor Society',
                              'Student Government',
                            ]
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

                  const SizedBox(height: 15),

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

                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sports',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: _sports,
                    items:
                        [
                              'Basketball (Varsity)',
                              'Badminton (Varsity)',
                              'Basketball Club',
                              'Badminton Club',
                              'Football Club',
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
                  const SizedBox(height: 5),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        final selectedCriteria = {
                          "communityType": _communityType,
                          "selectedLocations": _selectedLocations,
                          "size": _size,
                          "learning": _learning,
                          "majors": _majors,
                          "programs": _programs,
                          "housingReq": _housingReq,
                          "housingType": _housingType,
                          "clubs": _clubs,
                          "campusType": _campusType,
                          "sports": _sports,
                        };

                        Navigator.pop(context, selectedCriteria);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7FB480),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 14),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text("Enter"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
