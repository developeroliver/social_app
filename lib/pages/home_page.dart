import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/components/my_drawer.dart';
import 'package:social_app/components/my_list_tile.dart';
import 'package:social_app/components/my_post_button.dart';
import 'package:social_app/components/my_textfield.dart';
import 'package:social_app/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // firestore
  final FirestoreDatabase database = FirestoreDatabase();

  // text controller
  final TextEditingController _newPostController = TextEditingController();

  // post message
  void postMessage() {
    // only post message if there is something in the textfield
    if (_newPostController.text.isNotEmpty) {
      String message = _newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    _newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'S O C I A L  A P P',
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // textfield box for user to type
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: 'Say something',
                    obscureText: false,
                    controller: _newPostController,
                  ),
                ),

                // post button
                MyPostButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),

          // POSTS
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              // show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // get all posts
              final posts = snapshot.data!.docs;

              // no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No posts... Post something!'),
                  ),
                );
              }

              // return a list
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    // get each individual post
                    final post = posts[index];

                    // get data from each post
                    String message = post['PostMessage'];
                    String userEmail = post['UserEmail'];

                    // return a tile
                    return MyListTile(
                      title: message,
                      subtitle: userEmail,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
