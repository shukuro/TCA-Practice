//
//  TasksView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/13.
//

import SwiftUI
import ComposableArchitecture
import RealmSwift

struct Tasks: Equatable {
  var tasks:  [Task] = []
}

enum TasksAction: Equatable {
  case onAppear
  case onTap(id: ObjectId, completed: Bool)
  case onSwipe(id: ObjectId)
  case fetchTaskResponse(Result<[Task], RealmError>)
}

struct TasksEnvironment {
  var realmManager: RealmManager
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let tasksReducer = Reducer<Tasks, TasksAction, TasksEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    state.tasks = environment.realmManager.tasks
    return .none
    
  case .onTap(id: let id, completed: let completed):
    return environment.realmManager.updateTask(id: id, completed: !completed)
      .receive(on: environment.mainQueue)
      .catchToEffect(TasksAction.fetchTaskResponse)
    
  case .onSwipe(id: let id):
    return environment.realmManager.deleteTask(id: id)
      .receive(on: environment.mainQueue)
      .catchToEffect(TasksAction.fetchTaskResponse)

  case .fetchTaskResponse(.success(let response)):
    state.tasks = response
    return .none
    
  case .fetchTaskResponse(.failure):
    return .none
  }
}

struct TasksView: View {
//  @EnvironmentObject var realmManager: RealmManager
  let store: Store<Tasks, TasksAction>
  @State private var showAddTaskView = false
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack(alignment: .bottomTrailing) {
        List {
          ForEach(viewStore.tasks, id: \.id) { task in
            if !task.isInvalidated {
              TaskRow(
                store: Store(
                  initialState: TaskState(
                    task: task.title,
                    completed: task.completed
                  ),
                  reducer: taskReducer,
                  environment: TaskEnvironment()
                )
              )
                .onTapGesture {
                  viewStore.send(.onTap(id: task.id, completed: task.completed))
                }
                .swipeActions(edge: .trailing) {
                  Button(role: .destructive) {
                    viewStore.send(.onSwipe(id: task.id))
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }
                }
            }
          }
          .listRowSeparator(.hidden)
        }
        .onAppear {
          UITableView.appearance().backgroundColor = UIColor.clear
          UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
        
        SmallAddButton()
          .padding()
          .onTapGesture {
            showAddTaskView.toggle()
          }
        
      }
      .sheet(isPresented: $showAddTaskView) {
        AddTaskView(
          store: Store(
            initialState: AddTaskState(),
            reducer: addTaskReducer,
            environment: AddTaskEnvironment(
              realmManager: RealmManager()
            )
          )
        )
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
      .background(Color(hue: 0.086, saturation: 0.141, brightness: 0.972))
      .onAppear {
        viewStore.send(.onAppear)
      }
      .navigationTitle("My taks")
    }
  }
}

struct TasksView_Previews: PreviewProvider {
  static var previews: some View {
    TasksView(
      store: Store(
        initialState: Tasks(),
        reducer: tasksReducer,
        environment: TasksEnvironment(
          realmManager: RealmManager(),
          mainQueue: .main
        )
      )
    )
      .environmentObject(RealmManager())
  }
}
