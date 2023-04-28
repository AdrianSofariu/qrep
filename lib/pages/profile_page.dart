import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrep/components/chat_message.dart';
import 'package:qrep/components/threedots.dart';
import 'package:qrep/read_data/get_userdetails.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //get current user
  final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  //ChatGPT api
  late OpenAI openAI;

  //StreamSubscription? subscription;
  bool _isTyping = false;

  //send message function
  void _sendMessage() {
    String botResponse = '';

    FocusManager.instance.primaryFocus?.unfocus();
    ChatMessage message = ChatMessage(
        text: _controller.text, sender: Constants.userName.toString());

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    //send prompt to gpt model
    final request = ChatCompleteText(
      messages: [
        Map.of({
          "role": "assistant",
          "content":
              "The following is a conversation with an AI assistant of the QRep application. The assistant is helpful, creative, clever, and very friendly."
        }),
        Map.of({"role": "user", "content": message.text})
      ],
      maxToken: 500,
      model: ChatModel.gptTurbo,
    );

    //subscribe to gpt stream and get the answer fragments in a single string
    openAI.onChatCompletionSSE(request: request).listen((response) {
      botResponse += response.choices[0].message!.content;
    });

    //after getting all fragments display the message
    openAI.onChatCompletionSSE(request: request).last.then((_) {
      ChatMessage botMessage =
          ChatMessage(text: botResponse.trim(), sender: "Virtual Bud");

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  //connect to the OpenAi api
  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: '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',
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        isLog: true);
    super.initState();
  }

  //
  @override
  void dispose() {
    //subscription?.cancel();
    super.dispose();
  }

  //widget for the chat-gpt chatbot
  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Try the AI-powered chat!",
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => _sendMessage(),
          icon: const Icon(
            Icons.send,
            color: Colors.green,
          ),
        )
      ],
    ).px8();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Column(children: [
            Container(
              color: Colors.green[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  //greet user
                  Text(
                    'Hello, ${Constants.userName.toString()}!',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    padding: Vx.m8,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    })),
            if (_isTyping) const ThreeDots(),
            const SizedBox(height: 10),
            const Divider(
              height: 1.0,
            ),
            Container(
              child: _buildTextComposer(),
            )
          ]),
        ),
      ),
    );
  }
}
