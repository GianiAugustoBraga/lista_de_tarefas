import 'package:flutter/material.dart';
import 'package:lista_tarefas/pages/todo_list_page.dart';

void main() {
  // Função principal para execução
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Definindo a tela inicial do aplicativo como a página de lista de tarefas
      home: TodoListPage(),

      // Ocultando o banner de debug no canto superior direito
      debugShowCheckedModeBanner: false,
    );
  }
}
