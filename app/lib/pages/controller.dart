import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../database/database.dart';

class LoginPageController extends GetxController {
  final loginUserName = TextEditingController();
  final taskDetail = TextEditingController();

  RxList taskList = [].obs;
  RxList usersList = [].obs;
  RxList userStrList = [].obs;
  List<String> userIdList = [];
  RxString selectedUser = ''.obs;
  RxBool isUpdate = true.obs;

  List<dynamic> outputList = [];

  Future<bool> fetchTasks(int userId) async {
    taskList.value = await TasksDatabase.instance.findTasks(userId);
    return true;
  }

  Future<bool> fetchUsers() async {
    usersList.value = await TasksDatabase.instance.findUsers();
    userStrList.clear();
    for(int i = 0; i < usersList.value.length; i++) {
      userStrList.add(usersList.value[i]['userName']);
    }
    return true;
  }
}
