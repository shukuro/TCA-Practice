//
//  HeaderView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/25.
//

import SwiftUI
import ComposableArchitecture

struct HeaderState: Equatable {
  var userName: String = ""
  var userIconImage: String = "person.crop.circle"
}

enum HeaderAction {
  case onAppear
  case userIconTapped
  case changeIcon
  case fetchUserResponse(Result<User, ProviderError>)
}

struct HeaderEnvironment {
  var userClient: UserClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let headerReducer = Reducer<HeaderState, HeaderAction, HeaderEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  case .userIconTapped:
    // TODO: Set User Icon
    
    // 動作確認用
    return environment.userClient.fetch()
      .receive(on: environment.mainQueue)
      .catchToEffect(HeaderAction.fetchUserResponse)
  case .changeIcon:
    state.userIconImage = "star.fill"
    return .none
  case .fetchUserResponse(.success(let response)):
    state.userName = response.name
    return .none
  case .fetchUserResponse(.failure):
    return .none
  }
}

struct HeaderView: View {
  let store: Store<HeaderState, HeaderAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 16) {
        Button(action: {
          viewStore.send(.userIconTapped)
        }) {
          Image(systemName: viewStore.userIconImage)
            .resizable()
            .frame(width: 32, height: 32)
            .foregroundColor(.black)
        }
        
        Text(viewStore.userName)
          .font(.title2)
        
        Spacer()
        
        Button(action: {
          viewStore.send(.changeIcon)
        }) {
          Text("Change")
        }
      }
      .padding()
      .background(Color.cyan)
    }
  }
}

struct HeaderView_Previews: PreviewProvider {
  static var previews: some View {
    HeaderView(
      store: Store(
        initialState: HeaderState(),
        reducer: headerReducer,
        environment: HeaderEnvironment(
          userClient: .mockPreview(),
          mainQueue: .main
        )
      )
    )
  }
}
