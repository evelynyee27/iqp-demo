import 'package:flutter/material.dart';

class RegularChatbox extends StatefulWidget {
  final String schoolName;
  const RegularChatbox({super.key, required this.schoolName});

  @override
  State<RegularChatbox> createState() => _RegularChatboxState();
}

class _RegularChatboxState extends State<RegularChatbox> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // each message has: from (user/bot) + text
  final List<Map<String, String>> _messages = [];

  void _sendUserMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // store USER message
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
          "text": "Answer the question the user has regard ${widget.schoolName}.....\n\n\n\n\n\n",
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
        title: Text(widget.schoolName),
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
                          ?  const Color(0xFFE53E3E)
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
                      style: TextStyle(
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
                    foregroundColor: Color(0xFF7fb480)
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