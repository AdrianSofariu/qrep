import 'package:cloud_firestore/cloud_firestore.dart';


class Post {
  String title;
  String author;
  String text;
  Timestamp time;
  List<dynamic> tags = [];
  String? documentID;



  Post(
      this.title,
      this.author,
      this.text,
      this.time,
      this.tags
      );


  // creating a Post object from a firebase snapshot
  Post.fromSnapshot(DocumentSnapshot snapshot) :
      title = snapshot['title'],
      author = snapshot['author'],
      text = snapshot['text'],
      time = snapshot['time'],
      tags = snapshot['tags'],
      documentID = snapshot.id;

}
