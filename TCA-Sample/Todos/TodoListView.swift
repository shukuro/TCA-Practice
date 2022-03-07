//
//  TodoListView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/08.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
  var todos: IdentifiedArrayOf<Todo> = []
}

enum AppAction {
  case addButtonTapped
  case todo(index: UUID, action: TodoAction)
  case todoDelayCompleted
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(todoReducer.forEach(
    state: \.todos,
    action: /AppAction.todo(index:action:),
    environment: { _ in TodoEnvironment() }
  ),
  Reducer { state, action, environment in
    switch action {
    case .addButtonTapped:
      state.todos.insert(Todo(id: environment.uuid()), at: 0)
      return .none
    case .todo(index: _, action: .checkboxTapped):
      struct CancelDelayId: Hashable{}
      return Effect(value: .todoDelayCompleted)
        .debounce(id: CancelDelayId(), for: 1, scheduler: environment.mainQueue)
    case .todo(index: let index, action: let action):
      return .none
    case .todoDelayCompleted:
        state.todos.sort { $1.isComplete && !$0.isComplete }
      return .none
      
    }
  }
)
  .debug()

struct TodoListView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        List {
          ForEachStore(
            self.store.scope(state: \.todos, action: AppAction.todo(index:action:)),
            content: TodoView.init(store:))
        }
        .navigationTitle("Todos")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") {
              viewStore.send(.addButtonTapped)
            }
          }
        }
      }
    }
  }
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView(
      store: Store(
        initialState: AppState(
          todos: [
            Todo(
              id: UUID(),
              description: "Milk",
              isComplete: false
            ),
            Todo(
              id: UUID(),
              description: "Eggs",
              isComplete: false
            ),
            Todo(
              id: UUID(),
              description: "Hand Soap",
              isComplete: true
            )
          ]
        ),
        reducer: appReducer,
        environment: AppEnvironment(
          mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
          uuid: UUID.init)
      )
      
    )
  }
}
