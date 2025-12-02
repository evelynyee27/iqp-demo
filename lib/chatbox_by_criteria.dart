import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router.dart';

class ChatboxByCriteria extends StatefulWidget {
  const ChatboxByCriteria({super.key});

  @override
  State<ChatboxByCriteria> createState() => _ChatboxByCriteriaState();
}

class _ChatboxByCriteriaState extends State<ChatboxByCriteria> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // each message has: from (user/bot) + text
  final List<Map<String, String>> _messages = [];

  // list of categories for the popup
  final List<String> _categories = [
    "Academic Fit",
    "Career Opportunities",
    "Location & Environment",
    "Cost & Financial Aid",
    "Campus Life",
    "Size & Reputation",
  ];

  // currently selected categories
  final Set<String> _selectedCategories = {};

  void _sendUserMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        "from": "user",
        "text": text,
      });
    });

    _controller.clear();
    _scrollToBottom();
    _simulateBotResponse(text);
  }

  // fake bot reply
  void _simulateBotResponse(String userInput) {
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({
          "from": "bot",
          "text": "Bot received: $userInput",
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  // 🔹 what happens when you press Enter in the popup
  void _submitCategories() {
    if (_selectedCategories.isEmpty) return;

    final text = "Selected categories: ${_selectedCategories.join(', ')}";

    setState(() {
      _messages.add({
        "from": "user",
        "text": text,
      });
    });

    _scrollToBottom();
  }

  void _showCategoryPopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setPopupState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFFEFF8EF),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final double totalWidth = constraints.maxWidth;
                        const double spacing = 12;
                        final double itemWidth = (totalWidth - spacing) / 2;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: _categories.map((cat) {
                            final isSelected =
                                _selectedCategories.contains(cat);

                            return SizedBox(
                              width: itemWidth,
                              child: ElevatedButton(
                                onPressed: () {
                                  // update popup state
                                  setPopupState(() {
                                    if (isSelected) {
                                      _selectedCategories.remove(cat);
                                    } else {
                                      _selectedCategories.add(cat);
                                    }
                                  });
                                  // optional: also update parent
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? const Color(0xFF7FB480) // selected
                                      : Colors.white, // normal
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : const Color(0xFF7FB480),
                                  textStyle: const TextStyle(fontSize: 12),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  cat,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _submitCategories();
                        Navigator.pop(context);
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
      appBar: AppBar(
        title: const Text("Chatbox By Criteria"),
      ),
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

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
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
                        bottomLeft:
                            isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight:
                            isUser ? Radius.zero : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
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
                  onTap: _showCategoryPopup,
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
