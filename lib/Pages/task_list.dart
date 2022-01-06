import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mockapi_app/Api/task_apis.dart';
import 'package:mockapi_app/Model/task_model.dart';

import 'add_or_update_task.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<TaskModel> tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var res = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddOrUpdateTask()));
          if (res != null) {
            getData();
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.length == 0
              ? const Center(
                  child: Text('No Data'),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) => Dismissible(
                        key: Key('$index'),
                        onDismissed: (dd) {
                          deleteData(tasks[index].id);
                        },
                        background: Container(
                          child: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                        child: ListTile(
                          onTap: () async {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddOrUpdateTask(
                                          task: tasks[index],
                                        )));
                            if (res != null) {
                              getData();
                            }
                          },
                          leading: Container(
                            width: 70,
                            height: 70,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage('${tasks[index].avatar}'),
                              ),
                            ),
                          ),
                          title: Text('${tasks[index].name}'),
                        ),
                      )),
    );
  }

  void getData() async {
    setState(() => isLoading = true);
    tasks.clear();
    var res = await TaskApi.getTaskList();

    if (res.statusCode == 200) {
      var decoded = jsonDecode(res.body);
      if (decoded.isNotEmpty) {
        setState(() {
          for (var item in decoded) {
            tasks.add(TaskModel(
                id: item['id'],
                avatar: item['avatar'],
                name: item['name'],
                createdAt: item['createdAt']));
          }
        });
      }
    }
    setState(() => isLoading = false);
  }

  void deleteData(String? taskId) async {
    var res = await TaskApi.deleteTask(id: taskId);
    if (res.statusCode == 200) {
      getData();
    }
  }
}
