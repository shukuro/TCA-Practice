//
//  CheckDetailView.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/02/26.
//

import SwiftUI
import ComposableArchitecture

struct DetailState: Equatable {
  var check: CheckState
}

enum DetailAction {
  case onAppear
}

struct DetailEnvironment {
  
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  }
}

struct CheckDetailView: View {
  let store: Store<DetailState, DetailAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Text("Detail View")
        .onAppear {
          viewStore.send(.onAppear)
        }
    }
  }
}

struct CheckDetailView_Previews: PreviewProvider {
  static var previews: some View {
    CheckDetailView(
      store: Store(
        initialState: DetailState(
          check: CheckState(id: UUID(), isChecked: false, check: Check(id: 0, name: "name", memo: "memo"))
        ),
        reducer: detailReducer,
        environment: DetailEnvironment()
      )
    )
  }
}
