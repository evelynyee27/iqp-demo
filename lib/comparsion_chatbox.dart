import 'package:flutter/material.dart';

class School {
  final String name;
  final String info;

  School({required this.name, required this.info});

  String get logoAsset => 'assets/School logo/$name.png';
}

class ComparsionChatbox extends StatefulWidget {
  final List<String> listOfSchool;
  final bool isTchart;
  const ComparsionChatbox({
    super.key,
    required this.listOfSchool,
    required this.isTchart,
  });

  @override
  State<ComparsionChatbox> createState() => _ComparsionChatboxState();
}

class _ComparsionChatboxState extends State<ComparsionChatbox> {
  static const List<String> schools = [
    "Ashford University", 
    "Crestmont University", 
    "Fairview University", 
    "Sutton College", 
    "Valleyview University", 
    "Wakefield University"
  ];

  final List<School> _schoolList = schools.map((name) {
    return School(
      name: name,
      info:
          "Answer the question in regards to $name......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    );
  }).toList();
  
  late List<School> selectedSchools;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // each message has: from (user/bot) + text
  final List<Map<String, dynamic>> _messages = [];

  void _sendUserMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // store USER message
    setState(() {
      _messages.add({"from": "user", "text": text});
    });

    _controller.clear();
    _scrollToBottom();

    // OPTIONAL: simulate BOT reply
    _simulateBotResponse(text);
  }

  // fake bot reply
  void _simulateBotResponse(String userInput) {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        if (widget.isTchart) {
          _messages.add({
            "from": "bot",
            "widget": TwoSchoolInfoBubble(
              school1: selectedSchools[0],
              school2: selectedSchools[1],
              schools: _schoolList,
            ),
          });
        } else {
          _messages.add({
            "from": "bot",
            "widget": SchoolInfoBubble(schools: selectedSchools),
          });
        }
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    selectedSchools = _schoolList
        .where((school) => widget.listOfSchool.contains(school.name))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comparsion Chatbox")),
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

                if (msg.containsKey("widget")) {
                  return Align(
                    alignment: Alignment.centerLeft, // bot side
                    child: msg["widget"] as Widget,
                  );
                }

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
                      style: TextStyle(color: Colors.white),
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
                    foregroundColor: Color(0xFF7fb480),
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

class TwoSchoolInfoBubble extends StatefulWidget {
  School school1;
  School school2;
  final List<School> schools;
  TwoSchoolInfoBubble({
    super.key,
    required this.school1,
    required this.school2,
    required this.schools,
  });

  @override
  State<TwoSchoolInfoBubble> createState() => _TwoSchoolInfoBubbleState();
}

class _TwoSchoolInfoBubbleState extends State<TwoSchoolInfoBubble> {
  Widget _buildSchoolSelector({
    required School selected,
    required School other,
    required ValueChanged<School> onChanged,
  }) {
    return Expanded(
      child: Container(
        color: Color.fromRGBO(236, 226, 208, 1),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        // decoration: BoxDecoration(color: const Color(0xFFECE2D0)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<School>(
            value: selected,
            isExpanded: true,
            dropdownColor: const Color(0xFFECE2D0),
            itemHeight: null,

            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Color.fromRGBO(27, 77, 62, 1),
            ),

            selectedItemBuilder: (context) {
              return widget.schools.map((s) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // logo
                    Image.asset(s.logoAsset, width: 32, height: 32),
                    const SizedBox(height: 4),

                    // school name and arrow to the right of the school name
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 70,
                        child: Text(
                          s.name,
                          style: const TextStyle(
                            color: Color.fromRGBO(27, 77, 62, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList();
            },

            // items in the dropdown menu
            items: widget.schools.map((s) {
              return DropdownMenuItem<School>(
                value: s,
                child: Row(
                  children: [
                    Image.asset(s.logoAsset, width: 30, height: 30),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        s.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color.fromRGBO(27, 77, 62, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            onChanged: (School? newSchool) {
              if (newSchool == null) return;

              if (newSchool == other) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please select two different schools to compare.',
                    ),
                  ),
                );
                return;
              }

              onChanged(newSchool);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(15),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(113, 128, 150, 1),
            Color.fromRGBO(173, 193, 219, 1),
          ],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(16),
        ),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // schools
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // chatbot summary
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Summary of differences between schools given by bot...',
                            style: TextStyle(
                              color: Color.fromRGBO(236, 226, 208, 1),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Divider(color: Color.fromRGBO(236, 226, 208, 1)),

                    // school dropdowns
                    Row(
                      children: [
                        _buildSchoolSelector(
                          selected: widget.school1,
                          other: widget.school2,
                          onChanged: (newSchool) {
                            setState(() => widget.school1 = newSchool);
                          },
                        ),

                        SizedBox(width: 5),

                        _buildSchoolSelector(
                          selected: widget.school2,
                          other: widget.school1,
                          onChanged: (newSchool) {
                            setState(() => widget.school2 = newSchool);
                          },
                        ),
                      ],
                    ),

                    Divider(color: Color.fromRGBO(236, 226, 208, 1)),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.5),
                              ),

                              child: Text(
                                'Category 1',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.5),
                              ),

                              child: Text(
                                'Category 1',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.6),
                              ),

                              child: Text(
                                'Category 2',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.6),
                              ),

                              child: Text(
                                'Category 2',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.70),
                              ),

                              child: Text(
                                'Category 3',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.70),
                              ),

                              child: Text(
                                'Category 3',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.8),
                              ),

                              child: Text(
                                'Category 4',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(width: 5),

                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 0.8),
                              ),

                              child: Text(
                                'Category 4',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 1),
                              ),

                              child: Text(
                                'Category 5',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),

                          SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              width: 25,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(236, 226, 208, 1),
                              ),

                              child: Text(
                                'Category 5',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SchoolInfoBubble extends StatefulWidget {
  final List<School> schools;
  const SchoolInfoBubble({super.key, required this.schools});

  @override
  State<SchoolInfoBubble> createState() => _SchoolInfoBubbleState();
}

class _SchoolInfoBubbleState extends State<SchoolInfoBubble> {
  int _currentIndex = 0;
  bool _slideFromRight = true;

  School get _currentSchool => widget.schools[_currentIndex];

  void _setIndex(int newIndex, {required bool fromRight}) {
    if (newIndex < 0 || newIndex >= widget.schools.length) return;

    setState(() {
      _slideFromRight = fromRight;
      _currentIndex = newIndex;
    });
  }

  void _goPrev() => _setIndex(_currentIndex - 1, fromRight: false);
  void _goNext() => _setIndex(_currentIndex + 1, fromRight: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(113, 128, 150, 1),
            Color.fromRGBO(173, 193, 219, 1),
          ],
          begin: AlignmentGeometry.topCenter,
          end: AlignmentGeometry.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // previous button
              ElevatedButton(
                onPressed: _currentIndex > 0 ? _goPrev : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECE2D0),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text("← Prev"),
              ),

              // logo and a dropdown arrow to the right
              SizedBox(
                width: 140,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE2D0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<School>(
                      value: _currentSchool,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color.fromRGBO(27, 77, 62, 1),
                      ),
                      dropdownColor: const Color(0xFFECE2D0),
                      isExpanded: true,
                      selectedItemBuilder: (context) {
                        return widget.schools.map((s) {
                          return Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              s.logoAsset,
                              width: 40,
                              height: 40,
                            ),
                          );
                        }).toList();
                      },

                      // Items inside the dropdown menu
                      items: widget.schools.map((s) {
                        return DropdownMenuItem<School>(
                          value: s,
                          child: Row(
                            children: [
                              Image.asset(s.logoAsset, width: 32, height: 32),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  s.name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 77, 62, 1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: (School? newSchool) {
                        if (newSchool == null) return;
                        final newIndex = widget.schools.indexOf(newSchool);
                        if (newIndex == -1 || newIndex == _currentIndex) {
                          return;
                        }
                        _setIndex(
                          newIndex,
                          fromRight: newIndex > _currentIndex,
                        );
                      },
                    ),
                  ),
                ),
              ),

              // next button
              ElevatedButton(
                onPressed: _currentIndex < widget.schools.length - 1
                    ? _goNext
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECE2D0),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text("Next →"),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Animated info section (slides + fades)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final offsetTween = Tween<Offset>(
                begin: Offset(_slideFromRight ? 1.0 : -1.0, 0),
                end: Offset.zero,
              );
              return ClipRect(
                child: SlideTransition(
                  position: offsetTween.animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
              );
            },
            child: Column(
              key: ValueKey<int>(_currentIndex),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentSchool.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFECE2D0),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentSchool.info,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFECE2D0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
