import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:musicm/controller/player_controller.dart';
import 'package:musicm/screens/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../consts/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkcolor,
      appBar: AppBar(
        backgroundColor: bgDarkcolor,
        leading: Icon(
          Icons.sort_rounded,
          color: whitecolor,
        ),
        actions: [
          IconButton(
            onPressed: ()  async {
              Future<List<SongModel>> ls = controller.audioQuery.querySongs(
                  ignoreCase: true,
                  orderType: OrderType.ASC_OR_SMALLER,
                  sortType: null,
                  uriType: UriType.EXTERNAL);
              List<SongModel> lls = await ls;
              showSearch(
                  context: context,
                  delegate: MyDelegete(cpy: lls, controller: controller));
            },
            icon: Icon(Icons.search),
            color: whitecolor,
          ),
        ],
        title: Text(
          'Music-M',
          style: TextStyle(
              color: Colors.redAccent, fontSize: 20, fontFamily: 'regular'),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No song Found",
                style: TextStyle(color: whitecolor, fontSize: 18),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 4),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                        tileColor: bgcolor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        title: Text(
                          snapshot.data![index].displayNameWOExt,
                          style: TextStyle(fontSize: 15, color: whitecolor),
                        ),
                        subtitle: Text(
                          snapshot.data![index].artist!,
                          style: TextStyle(fontSize: 12, color: whitecolor),
                        ),
                        leading: QueryArtworkWidget(
                          id: snapshot.data![index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: whitecolor,
                            size: 32,
                          ),
                        ),
                        trailing: Text((snapshot.data![index].duration!/60000).round().toString()+"min",style: TextStyle(fontSize: 12,color: Colors.redAccent),),
                        onTap: () {
                          controller.playSong(snapshot.data![index].uri, index);
                          Get.to(() => Player(
                                songModel: snapshot.data!,
                              ));
                          // controller.playSong(snapshot.data![index].uri,index);
                        },
                      ),
                    
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class MyDelegete extends SearchDelegate {
  List<SongModel> cpy;
  PlayerController controller;
  MyDelegete({Key? key, required this.cpy,required this.controller});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else
            query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SongModel> lsp = cpy.where((searchresult) {
      final res = searchresult.displayNameWOExt.toLowerCase();
      final ip = query.toLowerCase();
      return res.contains(ip);
    }).toList();
    // List<String> sugg = [
    //   'Try by searching with name',
    //   'Try searching by artist name',
    //   'Try searching with singer name'
    // ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: lsp.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Obx(
              () => ListTile(
                tileColor: bgcolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                title: Text(
                  lsp[index].displayNameWOExt,
                  style: TextStyle(fontSize: 15, color: whitecolor),
                ),
                subtitle: Text(
                  lsp[index].artist!,
                  style: TextStyle(fontSize: 12, color: whitecolor),
                ),
                leading: QueryArtworkWidget(
                  id: lsp[index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    color: whitecolor,
                    size: 32,
                  ),
                ),
                trailing: controller.playIndex.value == index &&
                        controller.isPlaying.value
                    ? const Icon(
                        Icons.play_arrow,
                        color: whitecolor,
                        size: 26,
                      )
                    : null,
                onTap: () {
                  controller.playSong(lsp[index].uri, index);
                  Get.to(() => Player(
                        songModel: lsp,
                      ));
                  // controller.playSong(snapshot.data![index].uri,index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
