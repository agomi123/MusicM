// on_audio_query is a Flutter Plugin used to query audios/songs
//  🎶 infos [title, artist, album, etc..] from device storage.
// just_audio is a feature-rich audio player for Android, iOS, macOS, web, Linux and Windows

// On most operating systems, permissions aren't just granted to apps at install time. Rather, developers have to ask the user for permissions while the app is running.

// This plugin provides a cross-platform (iOS, Android) API to request permissions and check their status. You can also open the device's app settings so users can grant a permission.
// On Android, you can show a rationale for requesting a permission
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  var mx = 0.0.obs;
  var curr = 0.0.obs;

  @override
  void onInit() {
    checkPermission();
    super.onInit();
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      updateposition();
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  changeDurationtoSecond(seconds) {
    var duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }

  updateposition() {
    audioPlayer.durationStream.listen((event) {
      duration.value = event.toString().split(".")[0];
      mx.value = event!.inSeconds.toDouble();
    });
    audioPlayer.positionStream.listen((event) {
      position.value = event.toString().split(".")[0];
      curr.value = event.inSeconds.toDouble();
    });
  }

  checkPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkPermission();
    }
  }
}
