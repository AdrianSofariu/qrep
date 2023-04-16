import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrep/components/post_selection_card.dart';
import 'package:qrep/models/checklist_item.dart';
import 'package:qrep/models/post.dart';
import 'package:qrep/pages/review_doc_page.dart';

class Selector extends StatefulWidget {
  const Selector({super.key});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  //document IDs
  List<String> docIDs = [];
  final TextEditingController _searchController = TextEditingController();

  List _resultsList = [];
  List _allResults = [];
  final List _selectedItems = [];
  Future? resultsLoaded;

  //get docIDs
  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('time', descending: true)
        .get()
        .then(
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
    var data = await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('time', descending: true)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  //convert the list of posts to a list of posts and bools for a checklist
  //and navigate to AddPost Page
  navigateAndDisplayPage(BuildContext context) {
    List<ListItem> posts = [];
    for (var post in _selectedItems) {
      posts.add(ListItem(post: post, isChecked: true));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPDF(items: posts)),
    );
  }

  //alert dialog for completed process
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert"),
      content: const Text("Post was added successfully."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //function to add a post to the pdf
  void addToPdf(Post post) {
    _selectedItems.add(post);

    //display a message Box to show completed action
    showAlertDialog(context);
  }

  //add listener to the text controller
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  //to do
  _onSearchChanged() {
    searchResultsList();
  }

  //add query results to a list of searched items
  searchResultsList() {
    var showResults = [];

    //build list according to the search bar query
    if (_searchController.text != "") {
      for (var postSnapshot in _allResults) {
        Post post = Post.fromSnapshot(postSnapshot);
        var title = post.title.toLowerCase();
        List<dynamic> tags = post.tags;

        if (title.contains(_searchController.text.toLowerCase()) ||
            tags.contains(_searchController.text.toLowerCase())) {
          showResults.add(postSnapshot);
        }
      }
    } else {
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
        title: const Text('Choose some questions!'),
        actions: [
          IconButton(
              onPressed: () {
                navigateAndDisplayPage(context);
              },
              icon: const Icon(
                Icons.edit_document,
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
              child: ListView.builder(
                itemCount: _resultsList.length,
                itemBuilder: (BuildContext context, int index) =>
                    postSelectionCard(context, _resultsList[index], addToPdf),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
