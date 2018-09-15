class Projects {
  final List<Map<String, dynamic>> projects;

  Projects({this.projects});

  factory Projects.fromJson(List<dynamic> json) {
    return Projects(
      projects: List<Map<String, dynamic>>.from(json),
    );
  }
}

class Project {
  final int id;
  final String name;
  final String description;
  final List<dynamic> overview;

  Project({this.id, this.name, this.description, this.overview});

  factory Project.fromJson(id, Map<String, dynamic> json) {
    return Project(
        id: id,
        name: json["name"],
        description: json["description"],
        overview: json["overview"]);
  }
}

class ProjectSearch {
  final int id;
  final String name;
  final String description;

  ProjectSearch({this.id, this.name, this.description});

  factory ProjectSearch.fromJson(Map<String, dynamic> json) {
    return ProjectSearch(
        id: json["id"], name: json["name"], description: json["description"]);
  }
}

class RUser {
  bool loggedIn;
  Map<String, dynamic> user;

  RUser({this.loggedIn, this.user});

  factory RUser.fromJson(Map<String, dynamic> json) {
    return RUser(loggedIn: json["loggedIn"], user: json["user"]);
  }
}

class RWorkTimer {
  int startTime;

  RWorkTimer({this.startTime});

  factory RWorkTimer.fromJson(Map<String, dynamic> json) {
    return RWorkTimer(startTime: json["startTime"]);
  }
}

class RAdd {
  String status;
  List<dynamic> overview;

  RAdd({this.status, this.overview});

  factory RAdd.fromJson(Map<String, dynamic> json) {
    return RAdd(status: json["status"], overview: json["overview"]);
  }
}

class DeletedWork {
  int id;
  int user;
  int project;
  String workDate;
  String workFrom;
  String workTo;
  String comment;

  DeletedWork(
      {this.id,
      this.user,
      this.project,
      this.workDate,
      this.workFrom,
      this.workTo,
      this.comment});

  factory DeletedWork.fromJson(Map<String, dynamic> json) {
    return DeletedWork(
        id: json["id"],
        user: json["user"],
        project: json["project"],
        workDate: json["workDate"],
        workFrom: json["workFrom"],
        workTo: json["workTo"],
        comment: json["comment"]);
  }
}
