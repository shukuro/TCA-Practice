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
  case todo(index: Int, action: TodoAction)
  //    case todoCheckboxTapped(index: Int)
  //    case todoTextFieldChanged(index: Int, text: String)
}

struct AppEnvironment {
  
}

let appReducer: Reducer<AppState, AppAction, AppEnvironment> =
  todoReducer.forEach(
    state: \.todos,
    action: /AppAction.todo(index:action:),
    environment: { _ in TodoEnvironment() }
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
        environment: AppEnvironment()
      )
    )
  }
}
