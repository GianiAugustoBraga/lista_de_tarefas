import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo, // Tarefa a ser exibida
    required this.onDelete, // Função a ser chamada ao excluir a tarefa
  });

  final Todo todo;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      // Widget deslizante para ações rápidas
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(10),
          height: 60,
          // Conteúdo da tarefa
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Exibe a data e hora formatadas
              Text(
                DateFormat('dd/mm/yyyy - HH:mm').format(todo.dateTime),
                //todo.dateTime.toString(),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              // Exibe o título da tarefa
              Text(
                todo.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Parei aqui
        // Define a ação deslizante para a exclusão da tarefa
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            // Botão deslizante para excluir a tarefa
            SlidableAction(
              label: 'Deletar',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                // Chama a função de exclusão quando a ação é acionada
                onDelete(todo);
              },
            ),
          ],
        ),
      ),
    );
  }
}
