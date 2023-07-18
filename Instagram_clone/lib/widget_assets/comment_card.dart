import 'package:flutter/material.dart';
import 'package:instagram/services/comment_service.dart';
import 'package:instagram/theme/theme.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final userId;
  final userName;
  const CommentCard({Key? key, this.snap, this.userId, this.userName})
      : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLiked = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isLiked = widget.snap.data()["likes"].contains(widget.userId);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap.data()['profImage'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: widget.snap.data()['username'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                          text: ' ${widget.snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                      bottom: 4,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  if (widget.snap['likes'].length != 0)
                    Text(
                      "${widget.snap['likes'].length} Likes",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () => CommentService().likeComment(
                widget.snap['commentId'].toString(),
                widget.userId,
                widget.userName,
                widget.snap['uid'],
                widget.snap['likes'],
              ),
              icon: Icon(
                Icons.favorite,
                size: 16,
                color: isLiked ? Pallete.redColor : Pallete.whiteColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
