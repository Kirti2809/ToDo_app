import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/home.dart';

import '../database/database.dart';
import 'controller.dart';

class LoginView extends StatelessWidget {
  final loginPageController = Get.put(LoginPageController());
  Map<dynamic, dynamic> selectedDropDown = {'userName': 'Select User'};

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: loginPageController.fetchUsers(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            List userList = loginPageController.userStrList.value;
            if(userList.isEmpty) {
              loginPageController.selectedUser.value = "";
            } else {
              loginPageController.selectedUser.value = userList.first;
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Welcome', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, color: Colors.black)),
                          const SizedBox(height: 100),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: loginPageController.loginUserName,
                                    decoration: const InputDecoration(
                                      hintText: 'Username',
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Icon(Icons.person_outline, size: 20, color: Colors.blue),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: DropdownButton(
                                    value: loginPageController.selectedUser.value,
                                    onChanged: (String? item) {
                                      loginPageController.selectedUser.value = item!;
                                      loginPageController.loginUserName.text = item!;
                                    },
                                    items: userList.map<DropdownMenuItem<String>>((sItem) {
                                      return DropdownMenuItem(value: sItem, child: Text(sItem));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                              child: OutlinedButton(
                                onPressed: () async {
                                  if(loginPageController.loginUserName.text == '') {
                                    const snackBar = SnackBar(content: Text("Please select existing user or Add username"),);
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    return;
                                  }
                                  int userId;
                                  List<Map> users = await TasksDatabase.instance.findUser(loginPageController.loginUserName.text);
                                  if (users.isEmpty) {
                                    userId = await TasksDatabase.instance.insertUser(loginPageController.loginUserName.text);
                                  } else {
                                    userId = users[0]['userId'];
                                  }
                                  Get.offAll(HomeView(), arguments: userId);
                                },
                                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue), padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10))),
                                child: const Text('Login/Register', style: TextStyle(color: Colors.white, fontSize: 20)),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
