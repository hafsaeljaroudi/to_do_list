import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
//reference the box
  List toDoList = [];
  final _myBox = Hive.box("mybox");

//run this for the first time
  void createInitialData() {
    toDoList = [
      ["new task", false],
      ["create a TO DO", false]
    ];
  }

//
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

//
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
