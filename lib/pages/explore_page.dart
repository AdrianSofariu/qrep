import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrep/pages/add_post.dart';
import 'package:qrep/read_data/get_post.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  //document IDs
  List<String> docIDs = [];

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('questions').get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (element) {
              docIDs.add(element.reference.id);
            },
          ),
        );
  }

  //navigate to AddPost Page
  navigateAndDisplayPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPostPage()),
    );

    //reload the widget
    if(result)
    {
      docIDs.clear();
      setState(() {});
    }
  }

   Future deletePost(String id) async {
    await FirebaseFirestore.instance.collection('questions').doc(id).delete();
    docIDs.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
              onPressed: () {
                /*Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const AddPostPage(); //to do
                    },
                  ),
                );*/
                navigateAndDisplayPage(context);
              },
              icon: const Icon(
                Icons.add_circle,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: getDocId(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: GetPost(documentId: docIDs[index], deleteFunction: deletePost,),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
