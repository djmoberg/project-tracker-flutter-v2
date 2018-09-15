import 'package:flutter/material.dart';

import 'package:project_tracker/projectExplorer/user/Add.dart';
import 'package:project_tracker/projectExplorer/user/UserOverview.dart';
import 'package:project_tracker/utils/ResponseObjects.dart';

class User extends StatelessWidget {
  final VoidCallback _updateOverview;
  final Project _project;

  User(this._updateOverview, this._project);

  @override
  Widget build(BuildContext context) {
    return MyUser(_updateOverview, _project);
  }
}

class MyUser extends StatefulWidget {
  final VoidCallback _updateOverview;
  final Project _project;

  MyUser(this._updateOverview, this._project);

  @override
  _MyUserState createState() => _MyUserState(_updateOverview, _project);
}

class _MyUserState extends State<MyUser> {
  final VoidCallback _updateOverview;
  final Project _project;

  _MyUserState(this._updateOverview, this._project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserOverview(_project, _updateOverview),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var added = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => Add(_updateOverview)));
          if (added != null && added) {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Work added")));
          }
        },
      ),
    );
  }

  // int _index = 0;

  // @override
  // Widget build(BuildContext context) {
  //   List<Widget> _views = [
  //     Add(_updateOverview),
  //     UserOverview(),
  //   ];

  //   return Scaffold(
  //     body: _views[_index],
  //     resizeToAvoidBottomPadding: false,
  //     bottomNavigationBar: BottomNavigationBar(
  //       currentIndex: _index,
  //       onTap: (index) {
  //         setState(() {
  //           _index = index;
  //         });
  //       },
  //       items: <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.add),
  //           title: Text("Add"),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.calendar_today),
  //           title: Text("User Overview"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
