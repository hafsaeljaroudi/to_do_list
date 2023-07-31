import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mypersonalnotes/data/database.dart';
import 'package:mypersonalnotes/utilities/dialogue_box.dart';
import 'package:mypersonalnotes/utilities/todo_tile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//reference the box
  final _myBox = Hive.box("mybox");
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
//if this is the 1st time opening the app
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

//text controller
  final _controller = TextEditingController();

//list of to do lists

  final user = FirebaseAuth.instance.currentUser!;

//sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //check box was tapped
  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }
  //save new task

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

//create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveNewTask,
          controller: _controller,
        );
      },
    );
  }

  //delete new task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image

          // Rest of your content
          Scaffold(
            backgroundColor: Color.fromARGB(248, 167, 230, 220),
            appBar: AppBar(
              title: Text("TO DO"),
              backgroundColor: Color.fromARGB(248, 76, 87, 207),
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewTask,
              elevation: 0,
              backgroundColor: Color.fromARGB(248, 76, 87, 207),
              foregroundColor: Colors.black,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 82, 235, 255)
                          .withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.add),
              ),
            ),
            body: ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
