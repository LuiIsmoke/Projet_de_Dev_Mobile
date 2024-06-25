import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  Map<String, bool> filters = {
    'Todo': true,
    'In progress': false,
    'Done': false,
    'Bug': false,
  };

  @override
  void initState() {
    super.initState();
    tasks = [
      Task('Task 1', '', 'Todo'),
      Task('Task 2', '', 'In progress'),
      Task('Task 3', '', 'Done'),
      Task('Task 4', '', 'Bug'),
    ];
    filteredTasks = tasks;
  }

  void _addTask(String title, String description, String status) {
    setState(() {
      tasks.add(Task(title, description, status));
      _filterTasks();
    });
  }

  void _editTask(int index, String title, String description, String status) {
    setState(() {
      tasks[index] = Task(title, description, status);
      _filterTasks();
    });
  }

  void _filterTasks() {
    setState(() {
      filteredTasks = tasks.where((task) => filters[task.status]!).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: filters.keys.map((String key) {
              return CheckboxListTile(
                title: Text(key),
                value: filters[key],
                onChanged: (bool? value) {
                  setState(() {
                    filters[key] = value!;
                  });
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _filterTasks();
                Navigator.of(context).pop();
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            color: Colors.white,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _getStatusColor(task.status),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(task.title),
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(task.status),
              ),
              onTap: () {
                _showEditTaskDialog(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 71, 66, 66),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Todo':
        return Colors.grey;
      case 'In progress':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      case 'Bug':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddTaskDialog() {
    String title = '';
    String description = '';
    String status = 'Todo';

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Todo', 'In progress', 'Done', 'Bug']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addTask(
                  titleController.text,
                  descriptionController.text,
                  status,
                );
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditTaskDialog(int index) {
    Task task = tasks[index];
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);
    String status = task.status;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: ['Todo', 'In progress', 'Done', 'Bug']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editTask(
                  index,
                  titleController.text,
                  descriptionController.text,
                  status,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String title;
  String description;
  String status;

  Task(this.title, this.description, this.status);
}
