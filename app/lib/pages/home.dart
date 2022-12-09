import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/pages/controller.dart';

import 'login.dart';

class HomeView extends StatelessWidget {
  final loginPageController = Get.put(LoginPageController());

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int userId = Get.arguments;

    return FutureBuilder<bool>(
        future: loginPageController.fetchTasks(userId),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return DefaultTabController(
              length: 3,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Obx(
                  () => Scaffold(
                    appBar: AppBar(
                      actions: [
                        IconButton(
                            onPressed: () {
                              Get.offAll(LoginView());
                            },
                            icon: Icon(Icons.logout))
                      ],
                      bottom: const TabBar(tabs: [
                        Tab(text: 'All tasks'),
                        Tab(text: 'Not Completed'),
                        Tab(text: 'Completed'),
                      ]),
                      title: Text(loginPageController.loginUserName.text + ' ToDo List'),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TabBarView(
                        children: [
                          ListView.builder(
                              itemCount: loginPageController.taskList.value.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      loginPageController.taskList[index]['status'] == 0
                                          ? Checkbox(
                                              value: false,
                                              onChanged: (bool? value) async {
                                                await TasksDatabase.instance
                                                    .updateTask(loginPageController.taskList.value[index]['taskId'], loginPageController.taskList.value[index]['status'] == 1 ? 0 : 1);
                                                loginPageController.fetchTasks(userId);
                                                const snackBar = SnackBar(content: Text('Task moved to completed'));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              })
                                          : InkWell(
                                              onTap: () async {
                                                await TasksDatabase.instance
                                                    .updateTask(loginPageController.taskList.value[index]['taskId'], loginPageController.taskList.value[index]['status'] == 0 ? 1 : 0);
                                                loginPageController.fetchTasks(userId);
                                                const snackBar = SnackBar(content: Text('Task moved to not completed'));
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              },
                                              child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.undo_rounded, color: Colors.black45, size: 22)),
                                            ),
                                      Padding(padding: const EdgeInsets.all(10), child: Text(loginPageController.taskList.value[index]['task'])),
                                      InkWell(
                                        onTap: () async {
                                            Widget deleteButton = TextButton(
                                              child: const Text("Delete"),
                                              onPressed: () async {
                                                await TasksDatabase.instance.deleteTask(loginPageController.taskList[index]['taskId']);
                                                loginPageController.fetchTasks(userId);
                                                Get.back();
                                              },
                                            );
                                            Widget cancelButton = TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () async {
                                                Get.back();
                                              },
                                            );
                                            AlertDialog alert = AlertDialog(
                                              title: const Text("Delete task"),
                                              content: const Text("Are you sure to delete?"),
                                              actions: [
                                                deleteButton,
                                                cancelButton
                                              ],
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                        },
                                        child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 22)),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          ListView.builder(
                              itemCount: loginPageController.taskList.value.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Visibility(
                                    visible: loginPageController.taskList[index]['status'] == 0,
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: false,
                                            onChanged: (bool? value) async {
                                              await TasksDatabase.instance
                                                  .updateTask(loginPageController.taskList.value[index]['taskId'], loginPageController.taskList.value[index]['status'] == 1 ? 0 : 1);
                                              loginPageController.fetchTasks(userId);
                                              const snackBar = SnackBar(content: Text('Task moved to completed'));
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }),
                                        Padding(padding: const EdgeInsets.all(10), child: Text(loginPageController.taskList.value[index]['task'])),
                                        Spacer(),
                                        InkWell(
                                          onTap: () async {
                                            Widget deleteButton = TextButton(
                                              child: const Text("Delete"),
                                              onPressed: () async {
                                                await TasksDatabase.instance.deleteTask(loginPageController.taskList[index]['taskId']);
                                                loginPageController.fetchTasks(userId);
                                                Get.back();
                                              },
                                            );
                                            Widget cancelButton = TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () async {
                                                Get.back();
                                              },
                                            );
                                            AlertDialog alert = AlertDialog(
                                              title: const Text("Delete task"),
                                              content: const Text("Are you sure to delete?"),
                                              actions: [
                                                deleteButton,
                                                cancelButton
                                              ],
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                          child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 22)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          ListView.builder(
                              itemCount: loginPageController.taskList.value.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Visibility(
                                    visible: loginPageController.taskList[index]['status'] == 1,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await TasksDatabase.instance
                                                .updateTask(loginPageController.taskList.value[index]['taskId'], loginPageController.taskList.value[index]['status'] == 0 ? 1 : 0);
                                            loginPageController.fetchTasks(userId);
                                            const snackBar = SnackBar(content: Text('Task moved to not completed'));
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          },
                                          child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.undo_rounded, color: Colors.black45, size: 22)),
                                        ),
                                        Padding(padding: const EdgeInsets.all(10), child: Text(loginPageController.taskList.value[index]['task'])),
                                        InkWell(
                                          onTap: () async {
                                            Widget deleteButton = TextButton(
                                              child: const Text("Delete"),
                                              onPressed: () async {
                                                await TasksDatabase.instance.deleteTask(loginPageController.taskList[index]['taskId']);
                                                loginPageController.fetchTasks(userId);
                                                Get.back();
                                              },
                                            );
                                            Widget cancelButton = TextButton(
                                              child: const Text("Cancel"),
                                              onPressed: () async {
                                                Get.back();
                                              },
                                            );
                                            AlertDialog alert = AlertDialog(
                                              title: const Text("Delete task"),
                                              content: const Text("Are you sure to delete?"),
                                              actions: [
                                                deleteButton,
                                                cancelButton
                                              ],
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                          },
                                          child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 22)),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Widget addTask = addNewTaskDialog(userId, context);
                        showDialog(context: context, builder: (BuildContext context) => addTask);
                      },
                      child: const Icon(Icons.add, size: 30),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget addNewTaskDialog(int userId, context) {
    return AlertDialog(
      actions: [OutlinedButton(
        onPressed: () async {
          await TasksDatabase.instance.insertTask(loginPageController.taskDetail.text, userId);
          loginPageController.fetchTasks(userId);
          Get.back();
        },
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 10))),
        child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      ],
        title: const Text('Enter New Task', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter New Task', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
            const SizedBox(height: 30),
            TextFormField(
              controller: loginPageController.taskDetail,
              decoration: const InputDecoration(
                hintText: 'Enter Task details',
              ),
            ),
          ],
        ),
      );
  }
}
