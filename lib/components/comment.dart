import 'package:flutter/material.dart';
import 'package:social/types/comment.dart';

class CommentView extends StatelessWidget {
  final Comment comment;

  const CommentView({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avi = Image.asset("assets/images/no_avatar.png").image;

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: avi,
            ),
            Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alexa", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("@alexa", style: const TextStyle(fontSize: 14)),
                  ],
                )),
            const Spacer(),
            PopupMenuButton(
              onSelected: (String value) {
                // handle the user's selection
              },
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem(
                    value: 'Hide',
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.flag),
                        SizedBox(width: 5,),
                        Text('Report'),
                      ],
                    ),
                    onTap: () {
                    },
                  ),
                  PopupMenuItem(
                    value: 'Delete',
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 5,),
                        Text('Delete'),
                      ],
                    ),
                    onTap: () {
                    },
                  ),
                ];
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(comment.text, maxLines: 10,),
        ),
        Divider(),
      ],
    );
  }
}
