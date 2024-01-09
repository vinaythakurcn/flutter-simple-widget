import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> todo = ['TODO 1', 'TODO 2'];
  final TextEditingController taskNameController = TextEditingController();

  addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                height: 200,
                child: Column(
                  children: [
                    const Text('Add new todo', style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 24),
                    TextFormField(
                      maxLines: 3,
                      controller: taskNameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(20),
                        hintText: 'Task',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskNameController.value.text.isNotEmpty) {
                  setState(() {
                    todo.add(taskNameController.value.text);
                    taskNameController.clear();
                  });
                }
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < todo.length; index += 1)
            ListTile(
              key: Key('$index'),
              tileColor: (index + 1).isOdd ? oddItemColor : evenItemColor,
              title: Text(todo[index]),
              trailing: const Icon(Icons.drag_handle),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = todo.removeAt(oldIndex);
            todo.insert(newIndex, item);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
