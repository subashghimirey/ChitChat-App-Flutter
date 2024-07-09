import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BubbleMessage extends StatelessWidget {
  const BubbleMessage({
    super.key,
    required this.isMe,
    this.message,
    required this.username,
    required this.showUserImage,
    required this.profileimage,
    this.image,
  });

  final bool isMe;
  final String? message;
  // final String userImage;
  final String username;
  final bool showUserImage;
  final String profileimage;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMe == false && showUserImage)
          CircleAvatar(
            backgroundImage: NetworkImage(profileimage),
          ),
        const SizedBox(
          width: 10,
        ),
        Container(
          child: Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (image != null)
                    Container(
                        height: 150,
                        width: 200,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: CachedNetworkImage(
                          imageUrl: image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                  if (message != null)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      margin: showUserImage
                          ? const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 1)
                          : const EdgeInsets.symmetric(vertical: 1)
                              .copyWith(left: 42),
                      decoration: BoxDecoration(
                          color: isMe ? Colors.blueAccent : Colors.grey[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(1),
                            bottomLeft: isMe
                                ? const Radius.circular(18)
                                : const Radius.circular(0),
                            bottomRight: isMe
                                ? const Radius.circular(15)
                                : const Radius.circular(12),
                          )),
                      child: Text(
                        message!,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
