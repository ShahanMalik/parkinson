import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:parkinson/services/chat_servvices/screen/chat_screen.dart';
import 'package:photo_view/photo_view.dart';

class SingleMessage extends StatefulWidget {
  final String message;
  final bool isMe;
  final String time;
  final String imageUrl;
  final String type;

  SingleMessage(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.time,
      required this.imageUrl,
      required this.type})
      : super(key: key);

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          // color: Colors.red,
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          child: Container(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: widget.type == "image"
                  ? Colors.transparent
                  : widget.isMe
                      ? Color.fromARGB(255, 181, 242, 185)
                      : Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.type == "text"
                    ? Container(
                        margin: EdgeInsets.only(right: 18),
                        child: Text(
                          widget.message,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dismissible(
                                direction: DismissDirection.vertical,
                                key: Key(widget.imageUrl),
                                onDismissed: (direction) {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.black,
                                  child: Dialog(
                                    backgroundColor: Colors.black,
                                    child: PhotoView(
                                      enablePanAlways: true,
                                      customSize: Size(
                                          MediaQuery.of(context).size.width * 1,
                                          MediaQuery.of(context).size.height *
                                              0.8),
                                      enableRotation: true,
                                      imageProvider: CachedNetworkImageProvider(
                                          widget.imageUrl),
                                      backgroundDecoration:
                                          BoxDecoration(color: Colors.black),
                                      minScale:
                                          PhotoViewComputedScale.contained *
                                              0.8,
                                      maxScale:
                                          PhotoViewComputedScale.covered * 2,
                                      heroAttributes: PhotoViewHeroAttributes(
                                          tag: widget.imageUrl),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      height: 120,
                                      width: 120,
                                      child: LinearProgressIndicator(
                                        color: Colors.grey.shade200,
                                        backgroundColor: Colors.grey.shade100,
                                      ),
                                    ),
                                imageUrl: widget.imageUrl)),
                      ),
                Container(
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.time,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45,
                        ),
                      ),
                      widget.isMe
                          ? Icon(
                              (online == 'online')
                                  ? Icons.done_all
                                  : Icons.done,
                              size: 15,
                              color: Color.fromARGB(255, 1, 88, 146),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
