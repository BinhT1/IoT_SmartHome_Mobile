import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_home/apis/room_api.dart';
import 'package:smart_home/const/global.dart';
import 'package:smart_home/model/lamp.dart';
import 'package:smart_home/model/room.dart';
import 'package:smart_home/model/window.dart';
import 'package:smart_home/widget/lamp_card.dart';
import 'package:smart_home/widget/loading_indicator.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  LoadingStatus _loadingStatus = LoadingStatus.initial;

  Room room = Room.empty();
  List<Lamp> lamps = [];
  List<Window> windows = [];

  String emptyLamp = "";
  String emptyWindow = "";

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
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    Future.delayed(Duration.zero, () async {
      final args = ModalRoute.of(context)!.settings.arguments as Room;

      setState(() {
        room = args;
      });

      var res = await detailRoom(args.roomId!);

      if (res["result"] == "success") {
        var data = res["data"];
        var resLamps = data["lamps"] as List;
        var resWindows = data["windows"] as List;

        List<Lamp> tmpLamps = resLamps.map((e) => Lamp.fromJson(e)).toList();
        List<Window> tmpWindows =
            resWindows.map((e) => Window.fromJson(e)).toList();

        setState(() {
          lamps = tmpLamps;
          windows = tmpWindows;
        });
        setState(() {
          _loadingStatus = LoadingStatus.success;
        });
      } else {
        setState(() {
          _loadingStatus = LoadingStatus.fail;
        });
        Fluttertoast.showToast(
            msg: "Lỗi Khi Lấy Dữ Liệu",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      setState(() {
        emptyLamp = "Phòng chưa có đèn nào";
        emptyWindow = "Phòng chưa có sửa sổ nào";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            initData();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(room.name ?? ""),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      child: Text("Biểu đồ"),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Bóng Đèn",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    lamps.isEmpty
                        ? Text(emptyLamp)
                        : GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: List.generate(lamps.length, (index) {
                              return Center(
                                child: LampCard(lamp: lamps[index]),
                              );
                            }),
                          ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      "Cửa Sổ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_loadingStatus == LoadingStatus.loading) ...[
          const Opacity(
            opacity: 0.2,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
          const Center(child: LoadingIndicator())
        ]
      ],
    );
  }
}
