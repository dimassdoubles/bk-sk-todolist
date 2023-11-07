import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/my_search_bar.dart';
import 'package:todolist/todo.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _searchController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  final _editTitleController = TextEditingController();
  final _editDescController = TextEditingController();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _getAllTodo();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _editDescController.dispose();
    _editTitleController.dispose();
    super.dispose();
  }

  void _getAllTodo() async {
    final keyword = _searchController.text;
    if (keyword.replaceAll(" ", "").isNotEmpty) {
      _search();
      return;
    }

    final todos = await _dbHelper.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySearchBar(
            controller: _searchController,
            onKeywordChanged: (keyword) {
              _search();
            },
          ),
          const SizedBox(
            height: 32,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Todo",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                var todo = _todos[index];
                if (todo.completed) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    _editTitleController.text = todo.title;
                    _editDescController.text = todo.description;

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Todo'),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                controller: _editTitleController,
                                decoration: const InputDecoration(
                                    hintText: 'Judul todo'),
                              ),
                              TextField(
                                controller: _editDescController,
                                decoration: const InputDecoration(
                                    hintText: 'Deskripsi todo'),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Batalkan'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            onPressed: () {
                              _editTodo(todo);
                              Navigator.pop(context);
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    leading: todo.completed
                        ? IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () {
                              _check(todo);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.radio_button_unchecked),
                            onPressed: () {
                              _check(todo);
                            },
                          ),
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _removeTodo(todo);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                var todo = _todos[index];
                if (!todo.completed) {
                  return const SizedBox.shrink();
                }
                return GestureDetector(
                  onTap: () {
                    _editTitleController.text = todo.title;
                    _editDescController.text = todo.description;

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Todo'),
                        content: SizedBox(
                          width: 200,
                          height: 200,
                          child: Column(
                            children: [
                              TextField(
                                controller: _editTitleController,
                                decoration: const InputDecoration(
                                    hintText: 'Judul todo'),
                              ),
                              TextField(
                                controller: _editDescController,
                                decoration: const InputDecoration(
                                    hintText: 'Deskripsi todo'),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Batalkan'),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            onPressed: () {
                              _editTodo(todo);
                              Navigator.pop(context);
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: ListTile(
                    leading: todo.completed
                        ? IconButton(
                            icon: const Icon(Icons.check_circle),
                            onPressed: () {
                              _check(todo);
                            },
                          )
                        : IconButton(
                            icon: const Icon(Icons.radio_button_unchecked),
                            onPressed: () {
                              _check(todo);
                            },
                          ),
                    title: Text(todo.title),
                    subtitle: Text(todo.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _removeTodo(todo);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Tambah Todo'),
              content: SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Judul todo'),
                    ),
                    TextField(
                      controller: _descController,
                      decoration:
                          const InputDecoration(hintText: 'Deskripsi todo'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Batalkan'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  onPressed: () {
                    _addTodo();
                    Navigator.pop(context);
                  },
                  child: const Text('Tambah'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _removeTodo(Todo todo) {
    _dbHelper.deleteTodo(todo.id);
    _getAllTodo();
  }

  void _editTodo(Todo edited) {
    _dbHelper.updateTodo(Todo(
      id: edited.id,
      title: _editTitleController.text,
      description: _editDescController.text,
      completed: edited.completed,
    ));

    _editTitleController.text = "";
    _editDescController.text = "";

    _getAllTodo();
  }

  void _check(Todo todo) {
    _dbHelper.updateTodo(
      Todo(
        id: todo.id,
        description: todo.description,
        title: todo.title,
        completed: !todo.completed,
      ),
    );

    _getAllTodo();
  }

  void _addTodo() {
    debugPrint("_addTodo");

    final title = _titleController.text;
    final desc = _descController.text;
    final id = DateTime.now().microsecondsSinceEpoch;
    _dbHelper.insertTodo(
      Todo(
        id: id,
        title: title,
        description: desc,
        completed: false,
      ),
    );

    /// reset inputan todo
    setState(() {
      _titleController.text = "";
      _descController.text = "";
    });

    _getAllTodo();
  }

  void _search() async {
    final keyword = _searchController.text;

    if (keyword.replaceAll(" ", "").isEmpty) {
      debugPrint("_search empty string");
      _getAllTodo();
      return;
    }

    final todos = await _dbHelper.getTodoByTitle(keyword);
    setState(() {
      _todos = todos;
    });
  }
}
