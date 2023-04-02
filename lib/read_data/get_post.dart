import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrep/read_data/get_username.dart';

class GetPost extends StatelessWidget {
  final String documentId;

  const GetPost({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection
    CollectionReference questions =
        FirebaseFirestore.instance.collection('questions');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      //build the list
      child: FutureBuilder<DocumentSnapshot>(
        future: questions.doc(documentId).get(),
        builder: ((context, snapshot) {
          //get data
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            //tag list
            var myList = data['tags'] as List<dynamic>;

            //convert timestamp to datetime
            DateTime myDateTime = (data['time']).toDate();
            DateFormat.yMMMd().add_jm().format(myDateTime);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //post title
                Text(
                  '${data['title']}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent),
                ),
                const SizedBox(height: 12),
                //post text
                Text('${data['text']}',
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
                  for (var string in myList)
                    TextSpan(
                        // ignore: prefer_interpolation_to_compose_strings
                        text: '${'#' + string} ',
                        style: const TextStyle(color: Colors.white))
                ])),
                const SizedBox(height: 8),
                //get author
                GetUserName(documentId: data['author']),

                //time
                Text(
                  myDateTime.toString(),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 35),
              ],
            );
          }
          return const Text('loading...');
        }),
      ),
    );
  }
}
