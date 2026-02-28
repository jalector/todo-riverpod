import 'package:go_router/go_router.dart';
import '../pages/todo_page.dart';
import '../pages/add_todo_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TodoPage(),
    ),
    GoRoute(
      path: '/add-todo',
      builder: (context, state) => const AddTodoPage(),
    ),
  ],
);
