//
//  HeaderView.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/25.
//

import SwiftUI
import ComposableArchitecture

struct HeaderState: Equatable {
  
}

enum HeaderAction {
  case onAppear
  case userIconTapped
}

struct HeaderEnvironment {
  
}

let headerReducer = Reducer<HeaderState, HeaderAction, HeaderEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  case .userIconTapped:
    // TODO: Set User Icon
    return .none
  }
}

struct HeaderView: View {
  let store: Store<HeaderState, HeaderAction>
  
  var body: some View {
    WithViewStore(self.store) { ViewStore in
      HStack(spacing: 16) {
        Button(action: {
          ViewStore.send(.userIconTapped)
        }) {
          Image(systemName: "person.crop.circle")
            .resizable()
            .frame(width: 32, height: 32)
            .foregroundColor(.black)
        }
        
        Text("User Name")
          .font(.title2)
        
        Spacer()
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
        environment: HeaderEnvironment()
      )
    )
  }
}
