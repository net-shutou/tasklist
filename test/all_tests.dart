import 'add_edit_test.dart' as add_edit_test;
import 'complete_task_test.dart' as complete_task_test;
import 'illegal_test.dart' as illegal_test;
import 'task_test.dart' as task_test;
import 'task_list_widget_test.dart' as task_list_widget_test;
import 'widget_test.dart' as widget_test;
import 'task_manager_test.dart' as task_manager_test;
import 'task_item_test.dart' as task_item_test;
import 'task_input_test.dart' as task_input_test;
import 'task_item_builder_test.dart' as task_item_builder_test;
import 'task_list_controller_test.dart' as task_list_controller_test; // 追加

void main() {
  add_edit_test.main();
  complete_task_test.main();
  illegal_test.main();
  task_test.main();
  task_list_widget_test.main();
  widget_test.main();
  task_manager_test.main();
  task_item_test.main();
  task_input_test.main();
  task_item_builder_test.main();
  task_list_controller_test.main(); // 追加
}