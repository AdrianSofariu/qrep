import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrep/models/post.dart';
import 'package:qrep/read_data/get_userdetails.dart';
import 'package:qrep/read_data/get_username.dart';

Widget postCard(BuildContext context, DocumentSnapshot document, Function deleteFunction)
{
  final post = Post.fromSnapshot(document);

  //convert timestamp to datetime
  DateTime myDateTime = (post.time).toDate();
  DateFormat.yMMMd().add_jm().format(myDateTime);

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              post.title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent),
            ),
            const Text('         '),
            Constants.userEmail == post.author ? 
            ElevatedButton(onPressed: () => deleteFunction(post.documentID), child: const Text('Delete', style: TextStyle(color: Colors.white),)) :
            const Text(''),
          ],
        ),
        const SizedBox(height: 12),
        //post text
        Text(post.text,
            style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 18),
        //taglist
        const Text(
          'tags:',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        const SizedBox(height: 4),
        RichText(
            text: TextSpan(children: <InlineSpan>[
          for (var string in post.tags)
            TextSpan(
                // ignore: prefer_interpolation_to_compose_strings
                text: '${'#' + string} ',
                style: const TextStyle(color: Colors.white))
        ])),
        const SizedBox(height: 8),
        //get author
        GetUserName(documentId: post.author),
        //time
        Text(
          myDateTime.toString(),
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 35),
    ]),
  );
}


