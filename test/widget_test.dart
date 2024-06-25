import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/main.dart';

void main() {
  testWidgets('Add and edit task test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TodoApp());

    // Verify that our app starts with an empty list of tasks.
    expect(find.byType(ListTile), findsNothing);

    // Tap the add button and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the add task dialog is displayed.
    expect(find.text('Add Task'), findsOneWidget);

    // Enter task details and tap Add.
    await tester.enterText(find.byType(TextField).at(0), 'New Task');
    await tester.enterText(find.byType(TextField).at(1), 'Task description');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // Verify that the task is added to the list.
    expect(find.text('New Task'), findsOneWidget);

    // Tap on the task to edit.
    await tester.tap(find.text('New Task'));
    await tester.pumpAndSettle();

    // Verify that the edit task dialog is displayed.
    expect(find.text('Edit Task'), findsOneWidget);

    // Edit task details and tap Save.
    await tester.enterText(find.byType(TextField).at(0), 'Edited Task');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify that the task is edited in the list.
    expect(find.text('Edited Task'), findsOneWidget);
    expect(find.text('Task description'), findsNothing); // Since description is not displayed in the list
  });
}
