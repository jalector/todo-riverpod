import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_riverpood/pages/todo_page.dart';
import 'package:todo_riverpood/providers/todo_provider.dart';

void main() {
  group('TodoPage', () {
    testWidgets('should display empty state when there are no todos', (WidgetTester tester) async {
      // Build the app with ProviderScope
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const TodoPage(),
                ),
              ],
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify empty state message is displayed
      expect(
        find.text('No todos yet. Tap the + button to add one!'),
        findsOneWidget,
      );
    });

    testWidgets('should display 10 todos and validate the text of the last todo', (WidgetTester tester) async {
      // Set a larger viewport to ensure all items can be visible
      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Create a container to manage providers
      final container = ProviderContainer();
      
      // Add 10 todos to the provider before building the widget
      final notifier = container.read(todoProvider.notifier);
      for (int i = 1; i <= 10; i++) {
        notifier.addTodo('Todo $i');
      }

      // Build the app with UncontrolledProviderScope using the container
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const TodoPage(),
                ),
              ],
            ),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Scroll to the bottom to ensure all items are rendered
      final listView = find.byType(ListView);
      if (listView.evaluate().isNotEmpty) {
        await tester.drag(listView, const Offset(0, -2000));
        await tester.pumpAndSettle();
      }

      // Verify that 10 todos are displayed (each has a ListTile with title)
      final listTiles = find.byType(ListTile);
      expect(listTiles, findsNWidgets(10));

      // Verify the text of the first todo (Todo 10, which is at the top)
      expect(find.text('Todo 10'), findsOneWidget);
      
      // Validate the text of the last todo (Todo 1, which is at the bottom of the list)
      expect(find.text('Todo 1'), findsOneWidget);

      // Clean up
      container.dispose();
    });
  });
}
