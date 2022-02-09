//
//  TodoView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/02/09.
//

import SwiftUI
import ComposableArchitecture

struct Todo: Equatable, Identifiable {
  var description = ""
  let id: UUID
  var isComplete = false
}

enum TodoAction {
  case checkboxTapped
  case textFieldChanged(String)
}

struct TodoEnvironment {
}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, environment in
  switch action {
  case .checkboxTapped:
    state.isComplete.toggle()
    return .none
  case .textFieldChanged(let text):
    state.description = text
    return .none
  }
}

struct TodoView: View {
  let store: Store<Todo, TodoAction>
  
    var body: some View {
      WithViewStore(self.store) { viewStore in
        HStack {
          Button(action: { viewStore.send(.checkboxTapped) }) {
            Image(systemName: viewStore.isComplete ? "checkmark.square": "square")
          }
          .buttonStyle(PlainButtonStyle())
          
          TextField(
            "untitled todo",
            text: viewStore.binding(
              get: \.description,
              send: TodoAction.textFieldChanged
            )
          )
        }
        .foregroundColor(viewStore.isComplete ? .gray : nil)
      }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView(
          store: Store(
            initialState: Todo(
              description: "aaa",
              id: UUID(),
              isComplete: false),
            reducer: todoReducer,
            environment: TodoEnvironment()
          )
        )
    }
}
