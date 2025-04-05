import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart' as model;
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final bool isPlaceholder;

  const PostCard({Key? key, required this.snap, this.isPlaceholder = false})
    : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  bool _showComments = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.snap['comments'] != null) {
      commentLen = widget.snap['comments'].length;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleComments() {
    setState(() {
      _showComments = !_showComments;
    });
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      if (widget.isPlaceholder) {
        setState(() {
          final newComment = {
            'username':
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).getUser?.username ??
                'user',
            'text': _commentController.text,
          };

          if (widget.snap['comments'] != null) {
            (widget.snap['comments'] as List).add(newComment);
          } else {
            widget.snap['comments'] = [newComment];
          }

          commentLen = widget.snap['comments'].length;
          _commentController.clear();
        });
      } else {
        _commentController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.UserModel? user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['photoUrl'] ?? 'https://picsum.photos/200/300',
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'] ?? 'username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children:
                                  ['Delete']
                                      .map(
                                        (e) => InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16,
                                            ),
                                            child: Text(
                                              e,
                                              style: const TextStyle(
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                    );
                  },
                  icon: const Icon(Icons.more_vert, color: primaryColor),
                ),
              ],
            ),
          ),
          // IMAGE SECTION
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'] ?? 'https://picsum.photos/500/500',
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION
          Row(
            children: [
              IconButton(
                icon:
                    widget.snap['likes']?.contains(user?.uid) ?? false
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(
                          Icons.favorite_border,
                          color: primaryColor,
                        ),
                onPressed: () {
                  if (widget.isPlaceholder) {
                    setState(() {
                      if (widget.snap['likes']?.contains(user?.uid) ?? false) {
                        widget.snap['likes'].remove(user?.uid);
                      } else {
                        widget.snap['likes'].add(user?.uid);
                      }
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.comment_outlined, color: primaryColor),
                onPressed: _toggleComments,
              ),
              IconButton(
                icon: const Icon(Icons.send, color: primaryColor),
                onPressed: () {},
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          // CAPTION AND COMMENT COUNT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes']?.length ?? 0} likes',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'] ?? 'username',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: ' ${widget.snap['caption'] ?? ''}'),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: _toggleComments,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'] is Timestamp
                        ? (widget.snap['datePublished'] as Timestamp).toDate()
                        : widget.snap['datePublished'] ?? DateTime.now(),
                  ),
                  style: const TextStyle(fontSize: 12, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
