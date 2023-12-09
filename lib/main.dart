import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tasksToDo = [];
  final List<String> _tasksCompleted = [];
  String _newTask = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasksToDo.add(task);
      });
    }
  }

  void _markTaskCompleted(int index) {
    setState(() {
      String task = _tasksToDo.removeAt(index);
      _tasksCompleted.add(task);
    });
  }

  void _removeCompletedTask(int index) {
    setState(() {
      _tasksCompleted.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'To Do',
            ),
            Tab(
              text: 'Completed',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab for tasks to do
          ListView.builder(
            itemCount: _tasksToDo.length,
            itemBuilder: (context, index) {
              String task = _tasksToDo[index];

              return ListTile(
                title: Text(task),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle),
                  onPressed: () => _markTaskCompleted(index),
                ),
              );
            },
          ),

          // Tab for completed tasks
          ListView.builder(
            itemCount: _tasksCompleted.length,
            itemBuilder: (context, index) {
              String task = _tasksCompleted[index];

              return ListTile(
                title: Text(task),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeCompletedTask(index),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: TextField(
                onChanged: (task) => _newTask = task,
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    if (_newTask.isNotEmpty) {
                      if (_tasksToDo.contains(_newTask)) {
                        // Task already exists in the to do list
                        Navigator.of(context).pop();
                      } else {
                        // Add task to the to do list
                        _addTask(_newTask);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              ],
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
