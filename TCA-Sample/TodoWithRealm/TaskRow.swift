//
//  TaskRow.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/14.
//

import SwiftUI
import ComposableArchitecture

struct TaskState: Equatable {
  var task: String
  var completed: Bool
}

enum TaskAction {
  case checkboxTapped
}

struct TaskEnvironment {
}

let taskReducer = Reducer<TaskState, TaskAction, TaskEnvironment> { state, action, environment in
  switch action {
  case .checkboxTapped:
    state.completed.toggle()
    return .none
  }
}

struct TaskRow: View {
  var store: Store<TaskState, TaskAction>
  
  //    var task: String
  //    var completed: Bool
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 20) {
        Image(systemName: viewStore.state.completed ? "checkmark.circle" : "circle")
        Text(viewStore.state.task)
      }
    }
  }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRow(
          store: Store(
            initialState: TaskState(
              task: "Do Laundry",
              completed: true
            ),
            reducer: taskReducer,
            environment: TaskEnvironment()
          )
        )
    }
}
