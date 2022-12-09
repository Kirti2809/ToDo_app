# todo_app

A flutter application to keep track of your tasks that are completed or that need to be completed. Also this application could be used by team lead to assign the tasks to the team member and see the completion status of the tasks.

Libraries used: sqflite, path, getX

Flutter Complonents: StatelessWidget, DropdownButton, FutureBuilder, Obx, TabBarView, ListView.builder, Checkbox, InkWell, Card, Visibility

I have used sqflite for database storing and to interact with SQLite database.
I have used path package to define the location for storing the database on disk.
And GetX package is used for state-management, navigation.

In this application, first user needs to register and if the user is already registered then the user will be logged into user's account. Username is used for login and hence the username should be unique. When the user is registered for the first time it will create new entry in the users table. And if the username is already present in the table then it will logged in the user.

The users can shuffle betweenen the different users account, and see the tasks status and also can add or delete the tasks for the perticular user. There's a dropdown to select the different user. It will listdown all the users in the dropdown. For this I have used future builder so that it will fetch the list of the user in advance.

The users can create tasks for themselves and delete the tasks. Also user can change the status of the perticular task to the completed or not completed. When the task has been craeted for the user it will get stored in the tasks table against the perticular user. When the task has been deleted, it will get deleted from the tasks table.

When the user creates any task then the status of the task would be not completed by default.

User can see all the tasks, completed tasks and not completed tasks using the tabview.

When any new task has been created it will get added to the listview without refreshing the page, this has been done using the Obx from GetX library. And this is similar for the deletion of the task.

Also I have used GetX for navigation between the pages.
