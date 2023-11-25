import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../controllers/video_controller.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String videoId;
  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    required this.videoId,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  bool isPause = false;
  late VideoPlayerController videoPlayerController;

  final VideoController videoController = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: InkWell(
          onDoubleTap: () {
            videoController.likeVideo(widget.videoId);
          },
          onTap: () {
            if (isPause) {
              videoPlayerController.play();
              isPause = false;
            } else {
              videoPlayerController.pause();
              isPause = true;
            }
          },
          child: VideoPlayer(videoPlayerController)),
    );
  }
}
