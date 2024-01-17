import 'package:smart_home/apis/dio.dart';

dynamic getAllRoom() async {
  var res = await sendRequest("/api/v1/room/get-all", "GET");

  print(res);

  return res;
}

dynamic createRoom(String roomId, String name) async {
  var res = await sendRequest(
      "/api/v1/room/create", "POST", {"roomId": roomId, "name": name});

  print(res);

  return res;
}

dynamic detailRoom(String roomId) async {
  var res =
      await sendRequest("/api/v1/room/detail", "POST", {"roomId": roomId});

  print(res);

  return res;
}
