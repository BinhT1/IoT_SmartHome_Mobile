import 'package:flutter/material.dart';
import 'package:smart_home/apis/room_api.dart';
import 'package:smart_home/const/global.dart';
import 'package:smart_home/model/lamp.dart';
import 'package:smart_home/model/room.dart';
import 'package:smart_home/model/window.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  LoadingStatus _loadingStatus = LoadingStatus.initial;

  late Room room;
  List<Lamp> lamps = [];
  List<Window> windows = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initData() {
    Future.delayed(Duration.zero, () async {
      final args = ModalRoute.of(context)!.settings.arguments as Room;

      var res = await detailRoom(args.roomId!);

      if (res["result"] == "success") {
        var resLamps = res["lamps"] as List;
        var resWindows = res["windows"] as List;

        List<Lamp> tmpLamps = resLamps.map((e) => Lamp.fromJson(e)).toList();
        List<Window> tmpWindows =
            resWindows.map((e) => Window.fromJson(e)).toList();

        setState(() {
          lamps = tmpLamps;
          windows = tmpWindows;
        });
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
}
