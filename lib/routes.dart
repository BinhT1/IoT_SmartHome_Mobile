import 'package:smart_home/views/auth.dart';
import 'package:smart_home/views/home.dart';
import 'package:smart_home/views/room_page.dart';
import 'package:smart_home/views/setting.dart';

class PageNames {
  static const auth = "/";
  static const home = "/home";
  static const room = "/room";
  static const setting = "/setting";
}

dynamic getPages(context) {
  return {
    PageNames.auth: (context) => const Auth(),
    PageNames.home: (context) => const Home(),
    PageNames.room: (context) => const RoomPage(),
    PageNames.setting: (context) => const Setting()
  };
}
