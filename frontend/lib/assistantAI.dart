import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AssistantAIPage extends StatefulWidget {
  const AssistantAIPage({super.key});

  @override
  State<AssistantAIPage> createState() => _AssistantAIPageState();
}

class _AssistantAIPageState extends State<AssistantAIPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> conversationHistory = [];

  final List<Map<String, dynamic>> messages = [
    {
      'text':
          "Décris comment tu te sens, et laisse l’IA créer un look qui te ressemble.",
      'isUser': false,
      'isWelcome': true,
    },
  ];

  bool _isTyping = false;

  late AnimationController _dotsController;
  late Animation<double> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    _dotsAnimation = Tween<double>(begin: 0, end: 3).animate(_dotsController);
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _generateAIResponseFromGemini() async {
    final uri = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBu7M-d44SqodboloxSKRPJsarShop-gSo",
    );

    // Correct JSON structure for Gemini's generateContent endpoint
    final List<Map<String, dynamic>> contents = [
      {
        "role": "model", // The system prompt is a 'model' role
        "parts": [
          {
            "text":
                "Assistant: Si l'utilisateur exprime une humeur ou un état de santé, propose un look éco-responsable adapté. Réponds  court avec 3 avantages santé et 2 avantages environnementaux. Si l'utilisateur demande des conseils sur des vêtements, donne de bons conseils et un look adapté. **Si le message est trop vague (comme 'j'ai un vetemnt'), réponds: 'S'il te plaît, sois plus précis. Décris ton humeur ou le vêtement dont tu parles.'** Si le message est hors sujet, répond uniquement: 'Désolé, je ne peux pas fournir de réponse pour ce message.'",
          },
        ],
      },

      ...conversationHistory.map((message) {
        // Transform your history to the correct format
        return {
          "role": message['role'],
          "parts": [
            {"text": message['content'][0]['text']},
          ],
        };
      }).toList(),
    ];

    final body = jsonEncode({
      "contents": contents, // Use 'contents' instead of 'messages'
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        if (text != null && text.toString().trim().isNotEmpty) {
          final trimmedText = text.toString().trim();

          // Add the assistant's response to the history with the correct 'parts' key
          conversationHistory.add({
            "role": "model",
            "content": [
              {"type": "text", "text": trimmedText},
            ],
          });

          return trimmedText;
        } else {
          return "Désolé, je n'ai pas pu générer de réponse.";
        }
      } else {
        // Print the response body for more detailed debugging
        print("Erreur API ${response.statusCode}: ${response.body}");
        return "Erreur API ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      print("Erreur de connexion à l'API: $e");
      return "Erreur de connexion ";
    }
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'text': text, 'isUser': true});
      _controller.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Ajouter le message utilisateur au format exact
    conversationHistory.add({
      "role": "user",
      "content": [
        {"type": "text", "text": text},
      ],
    });

    final aiResponse = await _generateAIResponseFromGemini();

    if (!mounted) return;
    setState(() {
      messages.add({'text': aiResponse, 'isUser': false, 'isWelcome': false});
      _isTyping = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Lottie.asset('assets/loading2.json'), // ton animation Lottie
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Assistant AI",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(166, 146, 146, 1),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(height: 1, color: Color.fromARGB(255, 224, 224, 224)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset("assets/logo.png", height: 32, width: 32),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping && index == messages.length) {
                    return _buildTypingIndicator();
                  }

                  final message = messages[index];
                  final bool isUser = message['isUser'];
                  final bool isWelcome = message['isWelcome'] ?? false;
                  final String text = message['text'];

                  Color bgColor;
                  Color textColor;

                  if (isWelcome) {
                    bgColor = const Color(0xFFF5F0FF);
                    textColor = const Color(0xFF9B42FF);
                  } else if (isUser) {
                    bgColor = const Color.fromRGBO(82, 156, 161, 1);
                    textColor = Colors.white;
                  } else {
                    bgColor = Colors.transparent;
                    textColor = Colors.black;
                  }

                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: isUser
                          ? BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            )
                          : BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width,
                            ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: (isUser || isWelcome)
                              ? (bgColor ?? Colors.blueGrey)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          text ?? "",
                          style: TextStyle(
                            color: textColor ?? Colors.black,
                            fontSize: 16,
                            letterSpacing: !isUser ? 1 : 0,
                            fontWeight: !isUser
                                ? FontWeight.w500
                                : FontWeight.normal,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                onPressed: () {},
              ),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 150),
                  child: Scrollbar(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Écrire ici ...",
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isTyping
                        ? Colors.grey
                        : const Color.fromRGBO(82, 156, 161, 1),
                    shape: BoxShape.circle,
                  ),
                  child: _isTyping
                      ? const Text(
                          "...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
