import 'package:smart_home/apis/dio.dart';

dynamic createWindow(
    String roomId, String order, String name, int height) async {
  var res = await sendRequest("/api/v1/window/create", "POST",
      {"roomId": roomId, "name": name, "height": height, "windowOrder": order});

  print(res);

  return res;
}

dynamic changeName(String windowId, String name) async {
  var res = await sendRequest("/api/v1/window/change-name", "POST",
      {"windowId": windowId, "name": name});

  print(res);

  return res;
}

dynamic controlManual(String windowId, bool control) async {
  var res = await sendRequest("/api/v1/window/control-manual", "POST",
      {"windowId": windowId, "control": control});

  print(res);

  return res;
}

dynamic changeMode(String windowId, String mode) async {
  var res = await sendRequest("/api/v1/window/change-mode", "POST",
      {"windowId": windowId, "mode": mode});

  print(res);

  return res;
}

dynamic changeBreakpoint(String windowId, int breakpoint) async {
  var res = await sendRequest("/api/v1/window/change-breakpoint", "POST",
      {"windowId": windowId, "breakpoint": breakpoint});

  print(res);

  return res;
}

dynamic changeTimer(String windowId, List<String> timers) async {
  var res = await sendRequest("/api/v1/window/change-timers", "POST",
      {"windowId": windowId, "timers": timers});

  print(res);

  return res;
}

dynamic delete(String windowId) async {
  var res = await sendRequest(
      "/api/v1/window/delete", "POST", {"windowId": windowId});

  print(res);

  return res;
}
