//
//  TCASampleView.swift
//  SwiftUI-Combine-TCA
//
//  Created by shuhei.kuroda on 2022/02/24.
//

import SwiftUI
import ComposableArchitecture

struct ApiSampleState: Identifiable, Equatable {
  // same User struct
  var id: Int = 0
  var name: String = ""
  var age: Int = 0
  
}

enum ApiSampleAction {
  case viewAppear
  case buttonTapped
  case fetchUserResponse(Result<User, ProviderError>)
}

struct ApiSampleEnvironment {
  var userClient: UserClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let apiSampleReducer = Reducer<ApiSampleState, ApiSampleAction, ApiSampleEnvironment> { state, action, environment in
  switch action {
  case .viewAppear:
    state.id = 0
    state.name = "reset"
    state.age = 0
    return .none
    
  case .buttonTapped:
    return environment.userClient.fetch()
      .receive(on: environment.mainQueue)
      .catchToEffect(ApiSampleAction.fetchUserResponse)
      
  case .fetchUserResponse(.success(let response)):
    state.id = response.id
    state.name = response.name
    state.age = response.age
    return .none
    
  case .fetchUserResponse(.failure):
    return .none
  }
}

struct TCASampleView: View {
  var store: Store<ApiSampleState, ApiSampleAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        Text(viewStore.state.name)
        
        Text("\(viewStore.state.age)")
        
        Button(action: {
          viewStore.send(.buttonTapped)
        }) {
          Text("Get UserInfo")
            .padding()
        }
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

struct TCASampleView_Previews: PreviewProvider {
  static var previews: some View {
    TCASampleView(
      store: Store(
        initialState: ApiSampleState(id: 0, name: "test user", age: 30),
        reducer: apiSampleReducer,
        environment: ApiSampleEnvironment(
          userClient: .mockPreview(),
          mainQueue: .main
        )
      )
    )
  }
}
