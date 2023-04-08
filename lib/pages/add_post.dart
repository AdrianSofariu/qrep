import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';
import '../read_data/get_userdetails.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final titleController = TextEditingController();
  final textController = TextEditingController();

  final List<TextEditingController> _tagControllers = [];
  int controllerscount = 1;
  int tagfieldscount = 1;

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed.
    for (var controller in _tagControllers) {
      controller.dispose();
    }
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  //send post to firebase
  Future submitPost(String title, String text) async {
    //build tag list
    List<String> tags = [];
    for(var controller in _tagControllers){
        tags.add(controller.text.trim());
    }
    //add document to firebase collection
    await FirebaseFirestore.instance.collection('questions').add({
      'author': Constants.userEmail,
      'title' : title,
      'text' : text,
      'time' : Timestamp.now(),
      'tags' : tags,
    });
    if(mounted){
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Dynamic Text Fields'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create your own post!",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
                const SizedBox(height: 30),
                //title field
                MyTextField(
                  controller: titleController,
                  hintText: 'Title',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                //text field
                MyTextField(
                  controller: textController,
                  hintText: 'Write your text here...',
                  obscureText: false,
                ),
                const SizedBox(height: 20),
                //tag fields
                for (var i = 0; i < tagfieldscount; i++)
                  MyTextField(
                    controller:
                        _tagControllers.length > i ? _tagControllers[i] : null,
                    hintText: 'Write your tag here...',
                    obscureText: false,
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tagfieldscount++;
                      _tagControllers.add(TextEditingController());
                    });
                  },
                  child: const Text('Add Tag'),
                ),
                const SizedBox(height: 30),
                //submit button
                Container(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    child: GestureDetector(
                      onTap: () => submitPost(titleController.text.trim(), textController.text.trim()),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        width: 100,
                        height: 50,
                        
                        alignment: Alignment.center,
                        child: const Text('Submit Post', style: TextStyle(color: Colors.white,),),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
