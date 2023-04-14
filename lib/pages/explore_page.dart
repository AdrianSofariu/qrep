
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrep/components/post_card.dart';
import 'package:qrep/models/post.dart';
import 'package:qrep/pages/add_post.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  //document IDs
  List<String> docIDs = [];
  final TextEditingController _searchController = TextEditingController();

  List _resultsList = [];
  List _allResults = [];
  Future? resultsLoaded;

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('questions').orderBy('time', descending: true).get().then(
          // ignore: avoid_function_literals_in_foreach_calls
          (snapshot) => snapshot.docs.forEach(
            (element) {
              docIDs.add(element.reference.id);
            },
          ),
        );
  }

  //get Documents
  getDocumentsFromFirebase() async {
    var data = await FirebaseFirestore.instance.collection('questions').orderBy('time', descending: true).get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
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
      //docIDs.clear();
      setState(() {
        getDocumentsFromFirebase();
      });
    }
  }

  //function to delete a post
  Future deletePost(String id) async {
    await FirebaseFirestore.instance.collection('questions').doc(id).delete();
    //docIDs.clear();
    setState(() {
      getDocumentsFromFirebase();
    });
  }

  //add listener to the text controller
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  //to do
  _onSearchChanged(){
    searchResultsList();
  }

  //add query results to a list of searched items
  searchResultsList(){
    var showResults = [];

    //build list according to the search bar query
    if(_searchController.text != "")
    {
      for(var postSnapshot in _allResults){
        Post post = Post.fromSnapshot(postSnapshot);
        var title = post.title.toLowerCase();
        List<dynamic> tags = post.tags;

        if(title.contains(_searchController.text.toLowerCase()) || tags.contains(_searchController.text.toLowerCase()))
        {
          showResults.add(postSnapshot);
        }
      }
    }
    else
    {
      showResults = List.from(_allResults);
    }

    //return the results
    setState(() {
      _resultsList = showResults;
    });
  }


  //change dependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getDocumentsFromFirebase();
  }


  //dispose of the controller
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'search here',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            Expanded(
              child: /*FutureBuilder(
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
              ),*/
              ListView.builder(
                itemCount: _resultsList.length, 
                itemBuilder: (BuildContext context, int index) =>
                  postCard(context, _resultsList[index], deletePost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
