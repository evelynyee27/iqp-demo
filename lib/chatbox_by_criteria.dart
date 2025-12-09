import 'package:flutter/material.dart';
import 'router.dart';
import 'categories.dart';
import 'package:flutter/services.dart';

class ChatboxByCriteria extends StatefulWidget {
  const ChatboxByCriteria({super.key});

  @override
  State<ChatboxByCriteria> createState() => _ChatboxByCriteriaState();

  // @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}

class School {
  final String name;
  final String info;

  School({required this.name, required this.info});

  String get logoAsset => 'assets/School logo/$name.png';
}

class SchoolResultsGrid extends StatefulWidget {
  const SchoolResultsGrid({super.key, required this.schools});

  final List<School> schools;

  @override
  State<SchoolResultsGrid> createState() => _SchoolResultsGridState();
}

class _SchoolResultsGridState extends State<SchoolResultsGrid> {
  int? _openIndex; // which card is expanded

  @override
  Widget build(BuildContext context) {
    const double spacing = 12;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(113, 128, 150, 1),
            Color.fromRGBO(173, 193, 219, 1),
          ],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
      ), // background
      padding: const EdgeInsets.all(12),
      child: Column(children: _buildRows(spacing)),
    );
  }

  List<Widget> _buildRows(double spacing) {
    final List<Widget> rows = [];

    for (int i = 0; i < widget.schools.length; i += 2) {
      final int leftIndex = i;
      final int? rightIndex = (i + 1 < widget.schools.length) ? i + 1 : null;

      // up to 2 cards per row
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

      // if either card in this row is open, show full-width explanation under this row
      if (_openIndex != null &&
          (_openIndex == leftIndex || _openIndex == rightIndex)) {
        rows.add(const SizedBox(height: 8));
        rows.add(
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(236, 226, 208, 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.schools[_openIndex!].info,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        );
      }

      rows.add(SizedBox(height: spacing));
    }

    return rows;
  }

  Widget _buildCard(int index) {
    final school = widget.schools[index];
    final isOpen = _openIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _openIndex = isOpen ? null : index;
        });
      },
      child: Card(
        color: const Color(0xFFECE2D0),
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
                  Expanded(
                    child: Text(
                      school.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
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

class _ChatboxByCriteriaState extends State<ChatboxByCriteria> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];

  final List<String> _categories = [
    "Academic Fit",
    "Career Opportunities",
    "Campus Life",
    "Location & Environment",
    "Cost & Financial Aid",
    "Size & Reputation",
  ];
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

  // currently selected categories
  List<String> _selectedCategories = [];

  String formatCriteria(Map<String, dynamic> c) {
    final buffer = StringBuffer();

    buffer.writeln("Your selected criteria:");
    buffer.writeln("");

    void addField(String label, dynamic value) {
      if (value == null || value == "" || value == []) return;

      if (value is List) {
        if (value.isEmpty) return;
        buffer.writeln("• $label: ${value.join(", ")}");
      } else {
        buffer.writeln("• $label: $value");
      }
    }

    addField("Community type", c["communityType"]);
    addField("Preferred Locations", c["selectedLocations"]);
    addField("Size", c["size"]);
    addField("Learning System", c["learning"]);
    addField("Majors", c["majors"]);
    addField("Programs", c["programs"]);
    addField("Housing Requirement", c["housingReq"]);
    addField("Housing Type", c["housingType"]);
    addField("Clubs", c["clubs"]);
    addField("Campus Type", c["campusType"]);
    addField("Sports", c["sports"]);

    return buffer.toString().trim();
  }

  void _sendUserMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"from": "user", "type": "text", "text": text});
    });

    _controller.clear();
    _scrollToBottom();
    _simulateBotResponse();
  }

  // fake bot reply – sends the school results block
  void _simulateBotResponse() {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({
          "from": "bot",
          "type": "text",
          "text": "Here are some schools that might fit you:",
        });

        _messages.add({"from": "bot", "type": "schools"});
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _sortToDefault() {
    _selectedCategories.sort(
      (a, b) => _categories.indexOf(a).compareTo(_categories.indexOf(b)),
    );
  }

  void _showCriteriaFlowPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        int step = 0; // 0 = category selection, 1 = ranking
        List<String> ranking = List.from(_selectedCategories);

        return StatefulBuilder(
          builder: (context, setPopupState) {
            Widget buildCategoryStep() {
              return Expanded(
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "\nPlease select each category you are interested in",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double totalWidth = constraints.maxWidth;
                          const double spacing = 15;
                          final double itemWidth = (totalWidth - spacing) / 2;

                          return Wrap(
                            spacing: spacing,
                            runSpacing: spacing,
                            children: _categories.map((cat) {
                              final isSelected = _selectedCategories.contains(
                                cat,
                              );

                              return SizedBox(
                                width: itemWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setPopupState(() {
                                      if (isSelected) {
                                        _selectedCategories.remove(cat);
                                      } else {
                                        _selectedCategories.add(cat);
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? const Color(0xFF7FB480)
                                        : Colors.white,
                                    foregroundColor: isSelected
                                        ? Colors.white
                                        : const Color(0xFF7FB480),
                                    textStyle: const TextStyle(fontSize: 12),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(cat, textAlign: TextAlign.center),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedCategories.isEmpty) {
                            HapticFeedback.mediumImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No Categories has been selected. Please select at least one.',
                                ),
                              ),
                            );
                            return;
                          }
                          _sortToDefault();
                          ranking = List.from(_selectedCategories);

                          // new screen should come from the right
                          setPopupState(() {
                            step = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7FB480),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 14),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text("Next"),
                      ),
                    ],
                  ),
                ),
              );
            }

            Widget buildRankingStep() {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Please rank each category by weight by dragging each category",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 300,
                      child: ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        itemCount: ranking.length,
                        onReorder: (oldIndex, newIndex) {
                          setPopupState(() {
                            if (newIndex > oldIndex) newIndex -= 1;
                            final item = ranking.removeAt(oldIndex);
                            ranking.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = ranking[index];

                          return ListTile(
                            key: ValueKey(item),
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(item),
                            trailing: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setPopupState(() {
                              step = 0;
                            });
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
                          child: const Text("Back"),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _selectedCategories = List.from(ranking);
                            });
                            Navigator.pop(context);

                            final result = await Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    Categories(ranking: _selectedCategories),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                _messages.add({
                                  "from": "user",
                                  "type": "text",
                                  "text": formatCriteria(result),
                                });
                              });

                              _scrollToBottom();
                              _simulateBotResponse();
                            }
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
                      ],
                    ),
                  ],
                ),
              );
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              insetPadding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFEFF8EF),
                    child: SizedBox(
                      width: 350,
                      height: 440,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          final bool isOutgoing = animation is ReverseAnimation;
                          final curved = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );
                          final inFromRight = Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(curved);
                          final outToLeft = Tween<Offset>(
                            begin: Offset.zero,
                            end: const Offset(-1.0, 0.0),
                          ).animate(curved);
                          final offsetAnimation = isOutgoing
                              ? outToLeft
                              : inFromRight;
                          return ClipRect(
                            child: SlideTransition(
                              position: offsetAnimation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          key: ValueKey<int>(
                            step,
                          ), // 0 = categories, 1 = ranking
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (step == 0)
                              buildCategoryStep()
                            else
                              buildRankingStep(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 24,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chatbox By Criteria")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["from"] == "user";
                final type = msg["type"] ?? "text";
                if (type == "schools") {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SchoolResultsGrid(schools: _schoolList),
                  );
                }

                // normal text bubble
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFFE53E3E)
                          : const Color(0xFF718096),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : Radius.zero,
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          // input bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _showCriteriaFlowPopup,
                  child: Image.asset(
                    'assets/categories icon.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _sendUserMessage(),
                    decoration: InputDecoration(
                      hintText: "Enter message...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _sendUserMessage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF7FB480),
                  ),
                  child: const Text("Enter"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
