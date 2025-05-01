import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatServ extends StatefulWidget {
  final String? chatId;
  
  const ChatServ({super.key, this.chatId});

  @override
  State<ChatServ> createState() => _ChatServState();
}

class _ChatServState extends State<ChatServ> {
  final _userId = '1';
  final _assistantId = '2';

  List<ChatMessage> messages = [];
  bool isLoading = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadInitialMessage();
    
    // If we have a chat ID, we could load previous messages here
    if (widget.chatId != null && widget.chatId != 'new') {
      // Here you would typically load chat history based on the chat ID
      // For now, we'll just use the same initial message
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void loadInitialMessage() {
    setState(() {
      messages = [
        ChatMessage(
          text: "مرحبًا بك في مساعدك الذكي ServExcel",
          sender: _assistantId,
          timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        ),
      ];
    });
  }

  Future<String> sendQuestionWithHistory(String question) async {
    final url = Uri.parse('http://10.0.2.2:8000/chat');

    List<Map<String, String>> history = messages
        .where((m) => m.text.trim().isNotEmpty)
        .take(5)
        .map((m) => {
              'role': m.sender == _userId ? 'user' : 'assistant',
              'content': m.text,
            })
        .toList();

    history.add({'role': 'user', 'content': question});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_message': question,
        'history': history,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['answer'];
    } else {
      throw Exception('فشل الاتصال بالسيرفر');
    }
  }

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: _messageController.text,
      sender: _userId,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(userMessage);
      isLoading = true;
      _messageController.clear();
    });

    // Scroll to bottom after adding the message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      String answer = await sendQuestionWithHistory(userMessage.text);

      final botMessage = ChatMessage(
        text: answer,
        sender: _assistantId,
        timestamp: DateTime.now(),
      );

      setState(() {
        messages.add(botMessage);
        isLoading = false;
      });

      // Scroll to bottom after receiving the response
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('خطأ أثناء إرسال الرسالة: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFD6EBFF),
              radius: 20,
              child: Image.asset(
                "images/bot.png",
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'ServExcel',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Welcome Card
          if (messages.length <= 1)
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    "images/botl.png",
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'مرحبا بك في مساعدك الذكي\nServExcel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'باستخدام الذكاء الاصطناعي، هنقدر نعرف كل\nالإجابة والمستندات المطلوبة بسهولة',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Send a default first message
                      _messageController.text = "مرحبا";
                      sendMessage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B97FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: const Text(
                      'رسالة الآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message.sender == _userId;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF4B97FF) : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser)
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: const Color(0xFFD6EBFF),
                            child: Image.asset(
                              "images/bot.png",
                              width: 20,
                              height: 20,
                            ),
                          ),
                        if (!isUser) const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            message.text,
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFD6EBFF),
                  radius: 20,
                  child: Image.asset(
                    "images/bot.png",
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      hintText: '...اكتب رسالتك هنا',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => sendMessage(),
                    textInputAction: TextInputAction.send,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF4B97FF),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
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

class ChatMessage {
  final String text;
  final String sender;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timestamp,
  });
}