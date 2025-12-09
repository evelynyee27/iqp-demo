import 'package:flutter/material.dart';
import 'package:flutter_application_1/comparsion_chatbox.dart';
import 'package:flutter_application_1/regular_chatbox.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(27, 77, 62, 1),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class School {
  final String name;
  final String info;

  School({required this.name, required this.info});

  String get logoAsset => 'assets/School logo/$name.png';
}

class SchoolResultsGrid extends StatefulWidget {
  const SchoolResultsGrid({
    super.key,
    required this.schools,
    required this.isSelectMode,
    required this.selectedSchoolNames,
    required this.onToggleSelected,
  });

  final List<School> schools;
  final bool isSelectMode;
  final Set<String> selectedSchoolNames;
  final void Function(School school) onToggleSelected;

  @override
  State<SchoolResultsGrid> createState() => _SchoolResultsGridState();
}

class _SchoolResultsGridState extends State<SchoolResultsGrid> {
  @override
  Widget build(BuildContext context) {
    const double spacing = 12;

    return Column(children: _buildRows(spacing));
  }

  List<Widget> _buildRows(double spacing) {
    final List<Widget> rows = [];

    for (int i = 0; i < widget.schools.length; i += 2) {
      final int leftIndex = i;
      final int? rightIndex = (i + 1 < widget.schools.length) ? i + 1 : null;

      // ROW of up to 2 cards
      rows.add(
        Row(
          children: [
            Expanded(child: _buildCard(leftIndex)),
            if (rightIndex != null) ...[
              SizedBox(width: spacing),
              Expanded(child: _buildCard(rightIndex)),
            ],
          ],
        ),
      );
      rows.add(SizedBox(height: spacing));
    }

    return rows;
  }

  Widget _buildCard(int index) {
    final school = widget.schools[index];
    final bool isChecked = widget.selectedSchoolNames.contains(school.name);

    return GestureDetector(
      onTap: () {
        if (!widget.isSelectMode) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegularChatbox(schoolName: school.name),
            ),
          );
        } else {
          widget.onToggleSelected(school);
        }
      },
      child: Card(
        color: const Color.fromRGBO(255, 255, 255, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Image.asset(school.logoAsset, height: 75, fit: BoxFit.contain),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 75,
                    child: Text(
                      school.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),

                  if (!widget.isSelectMode)
                    const Icon(Icons.keyboard_arrow_right)
                  else
                    Checkbox(
                      value: isChecked,
                      onChanged: (_) {
                        widget.onToggleSelected(school);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool toggled = false;
  bool isSelect = false;
  String select = "Select";
  TextEditingController searchController = TextEditingController();
  List<School> filteredList = [];
  Set<String> selectedSchoolNames = {};
  static const List<String> schools = [
    "Ashford University",
    "Crestmont University",
    "Fairview University",
    "Sutton College",
    "Valleyview University",
    "Wakefield University",
  ];

  final List<School> _schoolList = schools.map((name) {
    return School(
      name: name,
      info:
          "Explanation of why $name fits the user's criteria......\n\n\n\n\n\n\n",
    );
  }).toList();

  @override
  void initState() {
    super.initState();
    filteredList = _schoolList; // show full list initially

    searchController.addListener(() {
      setState(() {});
      filterSchools(searchController.text);
    });
  }

  void filterSchools(String query) {
    setState(() {
      filteredList = _schoolList
          .where(
            (school) => school.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(27, 77, 62, 1),
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 5),
              // search bar
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,

                  child: SearchBar(
                    controller: searchController,
                    hintText: 'Search for schools',
                    hintStyle: WidgetStateProperty.all(TextStyle(fontSize: 12)),

                    elevation: WidgetStateProperty.all(1),
                    trailing: [
                      if (searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              filteredList = _schoolList;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // search by criteria
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // by criteria
                  ElevatedButton(
                    onPressed: () => context.push('/chatboxbycriteria'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(127, 180, 128, 1),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: const Text(
                      'Search by Criteria',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (isSelect) {
                          isSelect = false;
                          select = "Select Schools";
                        } else {
                          isSelect = true;
                          select = "Cancel";
                        }
                        if (!isSelect) {
                          selectedSchoolNames.clear();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(127, 180, 128, 1),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text(select, style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
              //SizedBox(height: 5),
              // comparison chatbox
              if (isSelect)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // comparison
                    ElevatedButton(
                      onPressed: () async {
                        if (toggled) {
                          if (selectedSchoolNames.length != 2) {
                            HapticFeedback.mediumImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select exactly 2 schools to compare.',
                                ),
                              ),
                            );
                            return;
                          }
                        } else {
                          if (selectedSchoolNames.length < 2) {
                            HapticFeedback.mediumImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select at least 2 schools to compare.',
                                ),
                              ),
                            );
                            return;
                          }
                        }
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ComparsionChatbox(
                              listOfSchool: selectedSchoolNames.toList(),
                              isTchart: toggled,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFACE4AA),
                        foregroundColor: const Color(0xFF1B4D3E),
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        minimumSize: const Size(0, 32 + 4), // height ~ Switch
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: const Text(
                        'Start Comparing',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 15),

                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text(
                            toggled
                                ? 'Compare two schools'
                                : 'Compare all schools',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 9, color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                    // toggle for comparison
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        // This bool value toggles the switch.
                        activeThumbColor: Colors.white,
                        activeTrackColor: Color.fromRGBO(229, 62, 62, 1),
                        inactiveThumbColor: Color.fromRGBO(113, 128, 150, 1),
                        inactiveTrackColor: Colors.white,

                        value: toggled,

                        onChanged: (bool value) {
                          if (value) {
                            // User is trying to turn compare ON
                            if (selectedSchoolNames.length > 2) {
                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You can only compare 2 schools.',
                                  ),
                                ),
                              );
                              return; // don’t turn it on
                            }
                          }

                          setState(() {
                            toggled = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (selectedSchoolNames.isEmpty) {
                            if (toggled && filteredList.length > 2) {
                              selectedSchoolNames = filteredList
                                  .take(2)
                                  .map((school) => school.name)
                                  .toSet();

                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Comparison mode is on. Only 2 schools can be selected.',
                                  ),
                                ),
                              );
                            } else {
                              selectedSchoolNames = filteredList
                                  .map((school) => school.name)
                                  .toSet();
                            }
                          } else {
                            selectedSchoolNames.clear();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedSchoolNames.isEmpty
                            ? const Color(0xFFACE4AA)
                            : Color.fromRGBO(229, 62, 62, 1),
                        foregroundColor: selectedSchoolNames.isEmpty
                            ? const Color(0xFF1B4D3E)
                            : Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                        minimumSize: const Size(0, 32 + 4), // height ~ Switch
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(
                        selectedSchoolNames.isEmpty
                            ? "Select All"
                            : "Clear All",
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(5),
                  children: [
                    SchoolResultsGrid(
                      schools: filteredList,
                      isSelectMode: isSelect,
                      selectedSchoolNames: selectedSchoolNames,
                      onToggleSelected: (school) {
                        setState(() {
                          final key = school.name;
                          final alreadySelected = selectedSchoolNames.contains(
                            key,
                          );

                          if (!alreadySelected) {
                            // try to select a new school
                            if (toggled && selectedSchoolNames.length >= 2) {
                              // Compare mode is ON and already have 2
                              HapticFeedback.mediumImpact();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You can only compare 2 schools at a time.',
                                  ),
                                ),
                              );
                              return;
                            }

                            selectedSchoolNames.add(key);
                          } else {
                            // Deselect is always allowed
                            selectedSchoolNames.remove(key);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
