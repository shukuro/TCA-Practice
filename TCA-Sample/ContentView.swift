//
//  ContentView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/02/06.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  var body: some View {
    NavigationView {
      List {
        NavigationLink("Todo sample") {
          TodoListView(
            store: Store(
              initialState: AppState(),
              reducer: appReducer,
              environment: AppEnvironment(
                mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                uuid: UUID.init)
            )
          )
        }
        
        NavigationLink("API with TCA") {
          TCASampleView(
            store:
              Store(
                initialState: ApiSampleState(),
                reducer: apiSampleReducer,
                environment: ApiSampleEnvironment(
                  userClient: .live,
                  mainQueue: .main
                )
              )
          )
        }
        
        NavigationLink("TCA Sample") {
          CheckListView(
            store:
              Store(
                initialState: CheckListState(),
                reducer: checkListReducer,
                environment: CheckListEnvironment(
                  checkListClient: .live,
                  mainQueue: .main,
                  uuid: UUID.init
                )
              )
          )
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
