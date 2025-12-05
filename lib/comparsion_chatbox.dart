import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';
import 'package:flutter/services.dart';

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
  final List<School> _schoolList = [
    School(
      name: "Ashford University",
      info:
          "Answer the question in regards to Ashford University......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
    School(
      name: "Crestmont University",
      info:
          "Answer the question in regards to Crestmont University......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
    School(
      name: "Fairview University",
      info:
          "Answer the question in regards to Fairview University......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
    School(
      name: "Sutton College",
      info:
          "Answer the question in regards to Sutton College......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
    School(
      name: "Valleyview University",
      info:
          "Answer the question in regards to Valleyview University......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
    School(
      name: "Wakefield University",
      info:
          "Answer the question in regards to Wakefield University......\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
    ),
  ];
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(25.0),

      decoration: const BoxDecoration(
        color: Color(0xFF718096), // same as bot text bubble
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
              // school 1
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.asset(
                      widget.school1.logoAsset,
                      width: 50,
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // school name
                        SizedBox(
                          width: 75,
                          child: Text(
                            widget.school1.name,
                            style: TextStyle(
                              color: Color.fromRGBO(236, 226, 208, 1),
                            ),
                          ),
                        ),
                        // dropdown
                        SizedBox(
                          width: 30,
                          height: 20,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECE2D0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.fromRGBO(27, 77, 62, 1),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<School>(
                                value: widget.school1,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color.fromRGBO(27, 77, 62, 1),
                                ),
                                dropdownColor: const Color(0xFFECE2D0),
                                isExpanded: true,

                                selectedItemBuilder: (context) {
                                  return widget.schools.map((s) {
                                    return SizedBox();
                                  }).toList();
                                },

                                items: widget.schools.map((s) {
                                  return DropdownMenuItem<School>(
                                    value: s,
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            s.logoAsset,
                                            width: 32,
                                            height: 32,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              s.name,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                  27,
                                                  77,
                                                  62,
                                                  1,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (School? newSchool) {
                                  if (newSchool == null) return;
                                  if (newSchool == widget.school2) {
                                    HapticFeedback.mediumImpact();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select two different schools to compare.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    widget.school1 = newSchool;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Divider(thickness: 1, color: Colors.black),
                    SizedBox(height: 5),
                    Text(
                      'Brief description of the school',
                      style: TextStyle(color: Color.fromRGBO(236, 226, 208, 1)),
                    ),
                    SizedBox(height: 5),
                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 1'),
                          ),
                        ),
                      ],
                    ),

                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 2'),
                          ),
                        ),
                      ],
                    ),

                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 3'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              VerticalDivider(),
              // school 2
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Image.asset(
                      widget.school2.logoAsset,
                      width: 50,
                      height: 50,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 75,
                          child:
                              // school name
                              Text(
                                widget.school2.name,
                                style: TextStyle(
                                  color: Color.fromRGBO(236, 226, 208, 1),
                                ),
                              ),
                        ),
                        // dropdown
                        SizedBox(
                          width: 30,
                          height: 20,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFECE2D0),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Color.fromRGBO(27, 77, 62, 1),
                                width: 1,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<School>(
                                value: widget.school1,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color.fromRGBO(27, 77, 62, 1),
                                ),
                                dropdownColor: const Color(0xFFECE2D0),
                                isExpanded: true,

                                selectedItemBuilder: (context) {
                                  return widget.schools.map((s) {
                                    return SizedBox();
                                  }).toList();
                                },

                                items: widget.schools.map((s) {
                                  return DropdownMenuItem<School>(
                                    value: s,
                                    child: SizedBox(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            s.logoAsset,
                                            width: 32,
                                            height: 32,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              s.name,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                  27,
                                                  77,
                                                  62,
                                                  1,
                                                ),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),

                                onChanged: (School? newSchool) {
                                  if (newSchool == null) return;
                                  if (newSchool == widget.school1) {
                                    HapticFeedback.mediumImpact();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select two different schools to compare.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  setState(() {
                                    widget.school2 = newSchool;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 1, color: Colors.black),
                    SizedBox(height: 5),
                    Text(
                      'Brief description of the school',
                      style: TextStyle(color: Color.fromRGBO(236, 226, 208, 1)),
                    ),
                    SizedBox(height: 5),
                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 1'),
                          ),
                        ),
                      ],
                    ),

                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 2'),
                          ),
                        ),
                      ],
                    ),

                    Divider(thickness: 1, color: Colors.black),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: 25,
                            alignment: Alignment.center,
                            child: Text('Category 3'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 1, color: Colors.black),
          Row(children: [Text('\nSummary of differences between schools\n')]),
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
        color: Color(0xFF718096), // same as bot text bubble
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
          // Top row: Prev | [logo dropdown] | Next
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // PREV
              ElevatedButton(
                onPressed: _currentIndex > 0 ? _goPrev : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECE2D0),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                ),
                child: const Text("← Prev"),
              ),

              // DROPDOWN WITH LOGO + ARROW INSIDE A BOX
              SizedBox(
                width: 140,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE2D0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color.fromRGBO(27, 77, 62, 1),
                      width: 1,
                    ),
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

                      // What the selected item looks like (logo only)
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
                                  overflow: TextOverflow.ellipsis,
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

              // NEXT
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
