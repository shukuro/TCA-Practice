//
//  ContentView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/02/06.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
  var todos: [Todo] = []
}

enum AppAction {
  case addButtonTapped
  case todo(index: Int, action: TodoAction)
  case todo DelayCompleted
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
//      return .concatenate(
//        .cancel(id: "todo completion effdect"),
//        Effect(value: .todoDelayCompleted)
//        .delay(for: 1, scheduler: DispatchQueue.main)
//        .eraseToEffect()
//        .cancellable(id: "completion effect")
//      )
      struct CancelDelayId: Hashable{}
      
      return Effect(value: .todoDelayCompleted)
        .debounce(id: CancelDelayId(), for: 1, scheduler: environment.mainQueue)
//        .delay(for: 1, scheduler: DispatchQueue.main)
//        .eraseToEffect()
//        .cancellable(id: CancelDelayId(), cancelInFlight: true)
      
    case .todo(index: let index, action: let action):
      return .none
      
    case .todoDelayCompleted:
        state.todos = state.todos
          .enumerated()
          .sorted(by: { lhs, rhs in
            (rhs.element.isComplete && !lhs.element.isComplete) ||
            lhs.offset < rhs.offset
          })
          .map(\.element)
      
      return .none
      
    }
  }
)
  .debug()
//let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
//    switch action {
//    case let .todoCheckboxTapped(index: index):
//        state.todos[index].isComplete.toggle()
//        return .none
//    case let .todoTextFieldChanged(index: index, text: text):
//        state.todos[index].description = text
//        return .none
//    }
//}.debug()

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    NavigationView {
      WithViewStore(self.store) { viewStore in
        List {
//          zip(viewStore.todos.indices, viewStore.todos)
          ForEachStore(
            self.store.scope(state: \.todos, action: AppAction.todo(index:action:))
          ) { todoStore in
            TodoView(store: todoStore)
          }
          
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: AppState(
          todos: [
            Todo(
              description: "Milk",
              id: UUID(),
              isComplete: false
            ),
            Todo(
              description: "Eggs",
              id: UUID(),
              isComplete: false
            ),
            Todo(
              description: "Hand Soap",
              id: UUID(),
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
