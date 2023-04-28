import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/color.dart';
import '../controller/player_controller.dart';

class Player extends StatelessWidget {
  final List<SongModel> songModel;
  const Player({super.key, required this.songModel});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    print(songModel[controller.playIndex.value].displayNameWOExt + "m");
    return Scaffold(
      backgroundColor: bgDarkcolor,
      appBar: AppBar(
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
                child: Container(
              height: 300,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 300,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
              child: QueryArtworkWidget(
                id: songModel[controller.playIndex.value].id,
                type: ArtworkType.AUDIO,
                artworkHeight: double.infinity,
                artworkWidth: double.infinity,
                nullArtworkWidget: const Icon(
                  Icons.music_note,
                  size: 48,
                  color: whitecolor,
                ),
              ),
              alignment: Alignment.center,
            )),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15))),
              child: Obx(
                () => Column(children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    songModel[controller.playIndex.value].displayNameWOExt,
                    style: TextStyle(color: bgDarkcolor, fontSize: 24),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    songModel[controller.playIndex.value].artist!,
                    style: TextStyle(color: bgDarkcolor, fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          controller.position.value,
                          style: TextStyle(color: bgDarkcolor, fontSize: 13),
                        ),
                        Expanded(
                          child: Slider(
                            value: controller.curr.value,
                            min:
                                const Duration(seconds: 0).inSeconds.toDouble(),
                            max: controller.mx.value,
                            onChanged: (value) {
                              controller.changeDurationtoSecond(value.toInt());
                              value = value;
                            },
                            thumbColor: slidercolor,
                            inactiveColor: bgcolor,
                            activeColor: slidercolor,
                          ),
                        ),
                        Text(
                          controller.duration.value,
                          style: TextStyle(color: bgDarkcolor, fontSize: 13),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.playIndex.value =
                                controller.playIndex.value - 1;
                            controller.playSong(
                                songModel[controller.playIndex.value].uri,
                                controller.playIndex.value);
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: 40,
                            color: bgDarkcolor,
                          )),
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: bgDarkcolor,
                        child: Transform.scale(
                            scale: 2.5,
                            child: IconButton(
                              onPressed: () {
                                if (controller.isPlaying.value) {
                                  controller.audioPlayer.pause();
                                  controller.isPlaying(false);
                                } else {
                                  controller.audioPlayer.play();
                                  controller.isPlaying(true);
                                }

                                //controller.playSong(songModel.uri, index);
                              },
                              icon: controller.isPlaying.value
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow_rounded),
                            )),
                      ),
                      IconButton(
                          onPressed: () {
                            controller.playIndex.value =
                                controller.playIndex.value + 1;
                            controller.playSong(
                                songModel[controller.playIndex.value ].uri,
                                controller.playIndex.value );
                          },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 40,
                            color: bgDarkcolor,
                          )),
                    ],
                  )
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
