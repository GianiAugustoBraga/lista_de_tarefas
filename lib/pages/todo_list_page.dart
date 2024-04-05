import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lista_tarefas/models/todo.dart';
import 'package:lista_tarefas/repositories/todo_repository.dart';
import 'package:lista_tarefas/widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Controller para o campo de texto onde o usuário insere novas tarefas
  final TextEditingController todoControler = TextEditingController();

  // Instância do repositório que lida com a persistência dos dados das tarefas
  final TodoRepository todoRepository = TodoRepository();

  // Lista de todas as tarefas
  List<Todo> todos = [];

  // Variáveis usadas para rastrear a tarefa que foi deletada temporariamente
  Todo? deletedTodo;
  int? deletedTodoPos;

  // Texto de erro exibido se o campo de texto estiver vazio ao tentar adicionar uma tarefa
  String? errorText;

  @override
  void initState() {
    super.initState();

    // Carregar a lista de tarefas ao iniciar o app
    todoRepository.getTodoList().then((value) => {
          setState(() {
            todos = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    // Construção da interface da página de lista de tarefas
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de entrada de texto para adicionar uma nova tarefa
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoControler,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicionar uma tarefa',
                            hintText: 'Ex. Estudar...',
                            errorText: errorText,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ))),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    // Botão para adicionar uma nova tarefa
                    ElevatedButton(
                      onPressed: () {
                        String text = todoControler.text;
                        // Verificar se o campo de texto está vazio
                        if (text.isEmpty) {
                          setState(() {
                            errorText = 'O campo não pode ser vazio!';
                          });
                          return;
                        }

                        // Adicionar a nova tarefa à lista
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoControler.clear();
                        todoRepository.saveTodoList(todos);
                        // Parei aqui....
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.all(10),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Lista de tarefas exibidas na interface
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // Contador de tarefas pendentes e botão para limpar todas as tarefas
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          "Você possui ${todos.length} tarefas pendentes!"),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: showDeleteTodoConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.delete_sweep_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função chamada ao deletar uma tarefa individualmente
  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.purple,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Função para exibir um diálogo de confirmação para limpar todas as tarefas
  void showDeleteTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(backgroundColor: Colors.purple),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodo();
            },
            child: Text('Limpar Tudo', style: TextStyle(color: Colors.white)),
            style: TextButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

// Função para deletar todas as tarefas
  void deleteAllTodo() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}
