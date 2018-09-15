import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';

import 'package:project_tracker/utils/Prefs.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const backend2 = "https://project-tracker-backend2.herokuapp.com";
const backend = "http://192.168.38.110:3000";

class Cookie {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String> getCookie() async {
    String cookie = await _prefs.then((prefs) {
      return (prefs.getString("cookie") ?? "");
    });
    return cookie;
  }

  static Future setCookie(value) async {
    await _prefs.then((prefs) {
      prefs.setString("cookie", value);
    });
  }
}

Future<bool> loggedIn() async {
  bool loggedIn;

  http.Response response = await http.get(backend + "/authenticate/loggedIn",
      headers: {"cookie": await Cookie.getCookie()});

  if (response.statusCode == 200) {
    Map<String, dynamic> body = json.decode(response.body);
    loggedIn = body["loggedIn"];
    Prefs().setUser(response.body);
  } else {
    throw Exception("Failed to load loggedIn");
  }

  return loggedIn;
}

Future login(username, password) async {
  http.Response response = await http.post(backend + "/authenticate/login",
      body: {"username": username, "password": password});
  if (response.statusCode == 200) {
    await Cookie.setCookie(response.headers["set-cookie"]);
    bool li = await loggedIn();
    print(li);
  } else {
    throw Exception("Failed to load login");
  }
}

Future logout() async {
  http.Response response = await http.get(backend + "/authenticate/logout",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    await Cookie.setCookie(response.headers["set-cookie"]);
  } else {
    throw Exception("Failed to load login");
  }
}

Future<List<Map<String, dynamic>>> getProjects() async {
  Projects projects;
  http.Response response = await http.get(backend + "/projects",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    projects = Projects.fromJson(json.decode(response.body));
    // print(projects.projects);
  } else {
    throw Exception("Failed to load projects");
  }
  return projects.projects;
}

Future<Project> getProject(int id) async {
  Project project;
  http.Response response = await http.get(backend + "/project/" + id.toString(),
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    project = Project.fromJson(id, json.decode(response.body));
    print(project.id);
  } else {
    throw Exception("Failed to load projects");
  }
  return project;
}

Future<int> getWorkTimer() async {
  RWorkTimer timer;
  http.Response response = await http.get(backend + "/workTimer",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    timer = RWorkTimer.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to load timer");
  }
  return timer.startTime;
}

Future setWorkTimer(int startTime) async {
  http.Response response = await http.post(backend + "/workTimer/new",
      headers: {"cookie": await Cookie.getCookie()},
      body: {"startTime": startTime.toString()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to set timer");
  }
}

Future deleteWorkTimer() async {
  http.Response response = await http.delete(backend + "/workTimer",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete timer");
  }
}

Future addWork(Map<String, dynamic> work) async {
  RAdd res;
  http.Response response = await http.post(backend + "/work/add",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(work));
  if (response.statusCode == 200) {
    res = RAdd.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to add work");
  }
  return res;
}

Future<bool> userExists(value) async {
  bool res = true;
  http.Response response = await http.get(
    backend + "/user/exists/" + value,
  );
  if (response.statusCode == 200) {
    res = response.body == "true";
  } else {
    throw Exception("Failed to load user exists");
  }
  return res;
}

Future registerUser(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/user/register",
      headers: {"Content-Type": "application/json"}, body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to register user");
  }
}

Future sendNewPassword(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/user/sendNewPassword",
      headers: {"Content-Type": "application/json"}, body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to send new password");
  }
}

Future registerProject(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/project/register",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to register project");
  }
}

Future<List<ProjectSearch>> findProjects(value) async {
  List<ProjectSearch> res = List();
  http.Response response = await http.get(
    backend + "/projects/find/" + value,
    headers: {"cookie": await Cookie.getCookie()},
  );
  if (response.statusCode == 200) {
    List<dynamic> resD = json.decode(response.body);
    resD.forEach((pS) {
      res.add(ProjectSearch.fromJson(pS));
    });
  } else {
    throw Exception("Failed to find projects");
  }
  return res;
}

Future<List<dynamic>> getUsers() async {
  List<dynamic> users;
  http.Response response = await http.get(backend + "/project/users",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    users = json.decode(response.body);
  } else {
    throw Exception("Failed to load projects");
  }
  return users;
}

Future newPassword(Map<String, dynamic> data) async {
  http.Response response = await http.put(backend + "/user/newPassword",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to update password");
  }
}

Future<List<DeletedWork>> getDeletedWork() async {
  List<DeletedWork> work = List();
  http.Response response = await http.get(backend + "/work/deleted",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    body.forEach((item) {
      work.add(DeletedWork.fromJson(item));
    });
  } else {
    throw Exception("Failed to load deleted work");
  }
  return work;
}

Future deleteTrash(int id) async {
  http.Response response = await http.delete(
      // backend + "/work/flutterTrash/" + id.toString(),
      backend + "/work/trash/" + id.toString(),
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete trash");
  }
}

Future<bool> moveToTrash(Map<String, dynamic> data) async {
  bool moved = false;
  http.Response response = await http.post(backend + "/work/trash",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    moved = response.body == "Work moved";
  } else {
    throw Exception("Failed to move to trash");
  }
  return moved;
}

Future deleteWork(int id) async {
  RAdd res;
  http.Response response = await http.delete(
      // backend + "/work/flutterDelete/" + id.toString(),
      backend + "/work/delete/" + id.toString(),
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    res = RAdd.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to delete work");
  }
  return res;
}

Future<List<dynamic>> getPendingJoinRequests() async {
  List<dynamic> projects;
  http.Response response = await http.get(backend + "/user/pendingJoinRequests",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    projects = json.decode(response.body);
    // print(projects.projects);
  } else {
    throw Exception("Failed to load pending join requests");
  }
  return projects;
}

Future sendJoinRequest(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/projects/joinRequest",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to send join request");
  }
}

Future deleteJoinRequest(String id) async {
  http.Response response = await http.delete(
    // backend + "/user/flutterPendingJoinRequest/" + id,
    backend + "/user/pendingJoinRequest/" + id,
    headers: {"cookie": await Cookie.getCookie()},
  );
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete join request");
  }
}

Future<List<dynamic>> getJoinRequests() async {
  List<dynamic> requests;
  http.Response response = await http.get(backend + "/project/joinRequests",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    requests = json.decode(response.body);
    // print(projects.projects);
  } else {
    throw Exception("Failed to load join requests");
  }
  return requests;
}

Future removeUser(String username) async {
  http.Response response = await http.delete(
      // backend + "/project/flutterRemoveUser/" + username,
      backend + "/project/removeUser/" + username,
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to remove user");
  }
}

Future makeAdmin(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/project/makeAdmin",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to make admin");
  }
}

Future deleteProjectJoinRequest(int userId) async {
  http.Response response = await http.delete(
      // backend + "/project/flutterJoinRequests/" + userId.toString(),
      backend + "/project/joinRequests/" + userId.toString(),
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete project join request");
  }
}

Future updateProject(Map<String, dynamic> data) async {
  http.Response response = await http.put(backend + "/project",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to update project");
  }
}

Future<bool> upload(File imageFile, String folder) async {
  // open a bytestream
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  // var uri = Uri.parse(backend + "/project/image");
  var uri = Uri.parse(
      "https://api.cloudinary.com/v1_1/dgtbkecfm/image/upload?api_key=181484295384343&upload_preset=jrwtxegn&folder=" +
          folder);

  // create multipart request
  var request = new http.MultipartRequest("POST", uri);

  // multipart that takes file
  var multipartFile = new http.MultipartFile('file', stream, length,
      filename: basename(imageFile.path));

  // add file to multipart
  request.files.add(multipartFile);

  // send
  var response = await request.send();
  print(response.statusCode);

  Stream<String> responseStream = response.stream.transform(utf8.decoder);

  await for (String value in responseStream) {
    print(value);
    Map<String, dynamic> res = json.decode(value);
    await sendImageUrl({"imageUrl": res["url"]});
  }

  // listen for response
  // response.stream.transform(utf8.decoder).listen((value) async {
  //   print(value);
  //   Map<String, dynamic> res = json.decode(value);
  //   await sendImageUrl({"imageUrl": res["url"]});
  // });

  return response.statusCode == 200;
}

Future sendImageUrl(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/project/image",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to send image url");
  }
}

Future<List<dynamic>> getImages() async {
  List<dynamic> images;
  http.Response response = await http.get(backend + "/project/images",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    images = json.decode(response.body);
    // print(projects.projects);
  } else {
    throw Exception("Failed to load images");
  }
  return images;
}

Future addUser(Map<String, dynamic> data) async {
  http.Response response = await http.post(backend + "/project/addUser",
      headers: {
        "cookie": await Cookie.getCookie(),
        "Content-Type": "application/json"
      },
      body: json.encode(data));
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to add user");
  }
}

Future deleteProject() async {
  http.Response response = await http.delete(backend + "/project",
      headers: {"cookie": await Cookie.getCookie()});
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception("Failed to delete project");
  }
}
