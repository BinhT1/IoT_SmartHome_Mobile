import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:smart_home/apis/window_api.dart' as window_api;
import 'package:smart_home/const/global.dart';
import 'package:smart_home/model/window.dart';
import 'package:smart_home/widget/loading_indicator.dart';

class WindowPage extends StatefulWidget {
  final Window args;
  const WindowPage({Key? key, required this.args}) : super(key: key);

  @override
  State<WindowPage> createState() => _WindowPageState();
}

class _WindowPageState extends State<WindowPage> {
  LoadingStatus _loadingStatus = LoadingStatus.initial;
  Window window = Window.empty();

  TextEditingController textEditingController = TextEditingController();

  bool isSettingBreakpoint = false;

  bool isSettingTimer = false;

  List<String> tmpTimer = [];

  DateTime tmpTimePicker = DateTime.now();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });

    setState(() {
      window = widget.args;
      tmpTimer = List.from(widget.args.timers!);

      textEditingController.text = widget.args.name!;
    });

    setState(() {
      _loadingStatus = LoadingStatus.success;
    });
  }

  String get getMode {
    if (window.mode == "auto") {
      return "tự động";
    } else if (window.mode == "timer") {
      return "hẹn giờ";
    } else {
      return "thủ công";
    }
  }

  Widget _manualMode() {
    return Container();
  }

  Widget _autoMode() {
    return Container();
  }

  Widget _timerMode() {
    return Container();
  }

  // Future<void> changeMode(String mode) async {
  //   Navigator.pop(context);
  //   setState(() {
  //     _loadingStatus = LoadingStatus.loading;
  //   });

  //   if (mode == "manual") {
  //     window_api.controlManual(window.windowId!, window.status!);
  //   }
  //   if (mode == "timer") {}

  //   var res = await window_api.changeMode(window.windowId!, mode);

  //   if (res["result"] == "success") {
  //     setState(() {
  //       window.mode = mode;
  //     });
  //     setState(() {
  //       _loadingStatus = LoadingStatus.success;
  //     });
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Lỗi Khi Lấy Dữ Liệu",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //     setState(() {
  //       _loadingStatus = LoadingStatus.fail;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(window.name ?? ""),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: ((context) {
                    return AlertDialog(
                      title: const Text("Đổi tên đèn"),
                      content: Container(
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: const InputDecoration(
                            hintText: "Nhập tên đèn",
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Huỷ',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (textEditingController.text == "") {
                              Fluttertoast.showToast(
                                  msg: "Bạn cần nhập tên đèn",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (textEditingController.text ==
                                window.name) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                              setState(() {
                                _loadingStatus = LoadingStatus.loading;
                              });
                              var res = await window_api.changeName(
                                  window.windowId!, textEditingController.text);

                              if (res["result"] == "success") {
                                setState(() {
                                  window.name = textEditingController.text;
                                  _loadingStatus = LoadingStatus.success;
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Lỗi Khi Lấy Dữ Liệu",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                setState(() {
                                  _loadingStatus = LoadingStatus.fail;
                                });
                              }
                            }
                          },
                          child: const Text('Đồng ý'),
                        ),
                      ],
                    );
                  }));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Bạn có chắc muốn xoá đèn?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Huỷ',
                            style: TextStyle(),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            var res = await window_api.delete(window.windowId!);

                            if (res["result"] == "success") {
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Lỗi Khi Lấy Dữ Liệu",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: const Text(
                            'Đồng ý',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Chế độ : $getMode",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          const Text(
                                            "Chọn Chế độ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (window.mode != "manual") {
                                                // changeMode("manual");
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Thủ công"),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (window.mode != "auto") {
                                                // changeMode("auto");
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Tự động"),
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (window.mode != "timer") {
                                                // changeMode("timer");
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text("Hẹn giờ"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: const Text("Đổi chế độ"))
                    ],
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
                  if (window.mode == "auto") ...[
                    _autoMode()
                  ] else if (window.mode == "timer") ...[
                    _timerMode()
                  ] else ...[
                    _manualMode()
                  ],
                  const SizedBox(
                    height: 12,
                  ),
                ],
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
      ),
    );
  }
}
