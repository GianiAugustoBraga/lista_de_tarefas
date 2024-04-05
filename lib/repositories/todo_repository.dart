import 'dart:convert';

import 'package:lista_tarefas/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo_list';

class TodoRepository {
  // Chave utilizada para armazenar a lista de tarefas no SharedPreferences
  late SharedPreferences sharedPreferences;

  // Função assíncrona para obter a lista de tarefas do SharedPreferences
  Future<List<Todo>> getTodoList() async {
    // Inicialização do SharedPreferences
    sharedPreferences = await SharedPreferences.getInstance();
    // Obtém a string JSON da lista de tarefas ou uma lista vazia, se não houver nada armazenado
    final String jsonSting = sharedPreferences.getString(todoListKey) ?? '[]';
    // Decodifica a string JSON em uma lista de objetos JSON
    final List jsonDecoded = json.decode(jsonSting) as List;
    // Mapeia os objetos JSON para instâncias da classe Todo utilizando o construtor fromJson
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  // Função para salvar a lista de tarefas no SharedPreferences
  void saveTodoList(List<Todo> todos) {
    // Codifica a lista de tarefas em uma string JSON
    final String jsonString = json.encode(todos);
    // Armazena a string JSON no SharedPreferences com a chave apropriada
    sharedPreferences.setString(todoListKey, jsonString);
  }
}
