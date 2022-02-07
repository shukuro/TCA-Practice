//
//  ContentView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/02/06.
//

import SwiftUI
import ComposableArchitecture

struct Todo: Equatable, Identifiable {
    var description = ""
    let id: UUID
    var isComplete = false
}

struct AppState: Equatable {
    var todos: [Todo] = []
}

enum AppAction {
    case todoCheckboxTapped(index: Int)
    case todoTextFieldChanged(index: Int, text: String)
}

struct AppEnvironment {
    
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
    switch action {
    case let .todoCheckboxTapped(index: index):
        state.todos[index].isComplete.toggle()
        return .none
    case let .todoTextFieldChanged(index: index, text: text):
        state.todos[index].description = text
        return .none
    }
}
struct ContentView: View {
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
//                    zip(viewStore.todos.indices, viewStore.todos)
                    ForEach(Array(viewStore.todos.enumerated()), id: \.element.id) { index, todo in
                        HStack {
                            Button(action: {
                                viewStore.send(.todoCheckboxTapped(index: index))
                            }) {
                                Image(systemName: todo.isComplete ? "checkmark.square": "square")
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            TextField(
                                "untitled todo",
                                text: viewStore.binding(
                                    get: { $0.todos[index].description },
                                    send: { .todoTextFieldChanged(index: index, text: $0) }
                                )
                            )
                        }
                        .foregroundColor(todo.isComplete ? .gray : nil)
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
