//
//  AddTaskView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/14.
//

import SwiftUI
import RealmSwift
import ComposableArchitecture

struct AddTaskState: Equatable {
  var title = ""
}

enum AddTaskAction {
  case textFieldChanged(String)
  case addButtonTapped
}

struct AddTaskEnvironment {
  var realmManager: RealmManager
}

let addTaskReducer = Reducer<AddTaskState, AddTaskAction, AddTaskEnvironment> { state, action, environment in
  switch action {
  case .textFieldChanged(let text):
    state.title = text
    return .none
    
  case .addButtonTapped:
    if state.title != "" {
      environment.realmManager.addTask(taskTitle: state.title)
    }
    return .none
  }
}

struct AddTaskView: View {
  @Environment(\.dismiss) var dismiss
  var store: Store<AddTaskState, AddTaskAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .leading, spacing: 20) {
        Text("Create a new task")
          .font(.title3).bold()
          .frame(maxWidth: .infinity, alignment: .leading)
        
        TextField("Enter your task here",
                  text: viewStore.binding(
                    get: \.title,
                    send: AddTaskAction.textFieldChanged
                  ))
          .textFieldStyle(.roundedBorder)
        
        Button {
          viewStore.send(.addButtonTapped)
          dismiss()
        } label: {
          Text("Add task")
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal)
            .background(Color(hue: 0.328, saturation: 0.796, brightness: 0.408))
            .cornerRadius(30)
        }
        
        Spacer()
      }
      .padding(.top, 40)
      .padding(.horizontal)
      .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
    }
  }
}

struct AddTaskView_Previews: PreviewProvider {
  static var previews: some View {
    AddTaskView(
      store: Store(
        initialState: AddTaskState(),
        reducer: addTaskReducer,
        environment: AddTaskEnvironment(realmManager: RealmManager())
      )
    )
  }
}
