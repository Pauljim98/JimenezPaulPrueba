import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> personalTasks = [];
  List<Task> workTasks = [];

  List<Task> get selectedTaskList => _showPersonalTasks ? personalTasks : workTasks;

  bool _showPersonalTasks = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_showPersonalTasks ? 'Tareas Personales' : 'Tareas de Trabajo'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _showConfirmationDialog();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: selectedTaskList.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: selectedTaskList[index],
            onCheckboxChanged: (value) {
              setState(() {
                selectedTaskList[index].isCompleted = value!;
                if (value) {
                  _showCompletionMessage();
                  _clearCompletedTasks();
                }
              });
            },
            onDeletePressed: () {
              setState(() {
                selectedTaskList.removeAt(index);
              });
            },
            onTap: () {
              _showTaskDetails(context, selectedTaskList[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Trabajo',
          ),
        ],
        currentIndex: _showPersonalTasks ? 0 : 1,
        onTap: (index) {
          setState(() {
            _showPersonalTasks = index == 0;
          });
        },
      ),
    );
  }

  void _addTask(BuildContext context) async {
    Task newTask = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String taskName = '';
        String taskDescription = ''; // Nueva variable para la descripción

        return AlertDialog(
          title: Text('Nueva Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  taskName = value;
                },
                decoration: InputDecoration(
                  hintText: 'Ingrese una nueva tarea',
                ),
              ),
              TextField(
                onChanged: (value) {
                  taskDescription = value;
                },
                decoration: InputDecoration(
                  hintText: 'Breve descripción',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(Task(name: taskName, description: taskDescription, isCompleted: false));
              },
              child: Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (newTask != null) {
      setState(() {
        if (_showPersonalTasks) {
          personalTasks.add(newTask);
        } else {
          workTasks.add(newTask);
        }
      });
    }
  }

  void _showTaskDetails(BuildContext context, Task task) async {
    Task editedTask = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );

    if (editedTask != null) {
      setState(() {
        int index = selectedTaskList.indexOf(task);
        selectedTaskList[index] = editedTask;
      });
    }
  }

  void _showCompletionMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea completada'),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Seguro que desea eliminar todas las tareas?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearAllTasks();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _clearAllTasks() {
    setState(() {
      selectedTaskList.clear();
    });
  }

  void _clearCompletedTasks() {
    setState(() {
      selectedTaskList.removeWhere((task) => task.isCompleted);
    });
  }
}

class Task {
  String name;
  String? description; // Puede ser nulo
  bool isCompleted;

  Task({required this.name, this.description, required this.isCompleted});
}

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onDeletePressed;
  final VoidCallback onTap;

  TaskItem({required this.task, required this.onCheckboxChanged, required this.onDeletePressed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.name),
      subtitle: Text(task.description ?? ''), // Muestra la descripción si no es nula
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: onCheckboxChanged,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: onDeletePressed,
      ),
      onTap: onTap,
    );
  }
}

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    _isCompleted = widget.task.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Tarea'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveChanges();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            SizedBox(height: 10),
            Checkbox(
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value!;
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              'Completada: ${_isCompleted ? "Sí" : "No"}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    Task editedTask = Task(
      name: _nameController.text,
      description: _descriptionController.text,
      isCompleted: _isCompleted,
    );
    Navigator.of(context).pop(editedTask);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}