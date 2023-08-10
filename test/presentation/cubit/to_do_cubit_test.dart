import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_list_provider/data/models/to_do_item_model.dart';
import 'package:todo_list_provider/domain/entities/to_do_item.dart';
import 'package:todo_list_provider/domain/usecases/to_do_actions.dart';
import 'package:todo_list_provider/presentation/notifier_providers/to_do_notifier_provider.dart';

class MockToDoActions extends Mock implements ToDoActions {}

class FakeToDoItem extends Fake implements ToDoItem {}

void main() {
  late ToDoNotifierProvider provider;
  late ToDoActions toDoActions;
  late List<ToDoItem> toDoItemsData;

  final ToDoItemModel toDoItemModel = ToDoItemModel(
    text: 'todoItem',
    guid: 'uniqueGuid',
    isComplete: true,
  );

  setUpAll(() {
    registerFallbackValue(FakeToDoItem());
  });

  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() {
    toDoActions = MockToDoActions();
    provider = ToDoNotifierProvider(
      toDoActions: toDoActions,
    );
    toDoItemsData = <ToDoItem>[toDoItemModel];
  });

  test('should have initial state', () {
    // assert
    const ToDoState toDoState = ToDoState(status: ToDoStatus.initial);
    expect(provider.state, toDoState);
  });

  test('should get initialized toDoItems', () async {
    // arrange
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);

    // act
    await provider.initializeToDoItems();

    // assert
    final ToDoState state = provider.state;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, toDoItemsData);
  });

  test('should add item to toDoItems', () async {
    // arrange
    final List<ToDoItem> expectedAddedToDoItems = <ToDoItem>[toDoItemModel, toDoItemModel];
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);
    when(() => toDoActions.setToDoItems(any())).thenAnswer((_) async {});
    final List<ToDoState> states = <ToDoState>[];
    provider.addListener(() {
      final ToDoState state = provider.state;
      states.add(state);
    });

    // act
    await provider.initializeToDoItems();
    await provider.addToDoItem(toDoItemModel);

    // assert
    ToDoState state = states.first;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, toDoItemsData);

    state = states.last;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, expectedAddedToDoItems);
  });

  test('should edit item in toDoItems', () async {
    // arrange
    final ToDoItem updatedEditedToDoItemModel = toDoItemModel.copyWith(text: 'updatedText');
    final List<ToDoItem> expectedEditedToDoItems = <ToDoItem>[updatedEditedToDoItemModel];
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);
    when(() => toDoActions.setToDoItems(any())).thenAnswer((_) async {});
    final List<ToDoState> states = <ToDoState>[];
    provider.addListener(() {
      final ToDoState state = provider.state;
      states.add(state);
    });

    // act
    await provider.initializeToDoItems();
    await provider.editToDoItem('uniqueGuid', 'updatedText');

    // assert
    ToDoState state = states.first;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, toDoItemsData);

    state = states.last;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, expectedEditedToDoItems);
  });

  test('should remove item from toDoItems', () async {
    // arrange
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);
    when(() => toDoActions.setToDoItems(any())).thenAnswer((_) async {});
    final List<ToDoState> states = <ToDoState>[];
    provider.addListener(() {
      final ToDoState state = provider.state;
      states.add(state);
    });

    // act
    await provider.initializeToDoItems();
    await provider.removeToDoItem(toDoItemModel);

    // assert
    ToDoState state = states.first;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, toDoItemsData);

    state = states.last;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, <ToDoItem>[]);
  });

  test('should change completion of toDoItem from toDoItems', () async {
    // arrange
    final ToDoItem updatedChangedToDoItemModel = toDoItemModel.copyWith(isComplete: false);
    final List<ToDoItem> expectedChangedToDoItems = <ToDoItem>[updatedChangedToDoItemModel];
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);
    when(() => toDoActions.setToDoItems(any())).thenAnswer((_) async {});
    final List<ToDoState> states = <ToDoState>[];
    provider.addListener(() {
      final ToDoState state = provider.state;
      states.add(state);
    });

    // act
    await provider.initializeToDoItems();
    await provider.changeCompletionOfToDoItem(toDoItemModel);

    // assert
    ToDoState state = states.first;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, toDoItemsData);

    state = states.last;
    expect(state.status, ToDoStatus.loaded);
    expect(state.items, expectedChangedToDoItems);
  });
}
