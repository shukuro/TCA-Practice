//
//  CheckRowView.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/02/26.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct CheckState: Equatable, Identifiable {
  var id: UUID
  var isChecked: Bool
  var check: Check
}

struct Check: Codable, Equatable, Identifiable {
  var id: Int
  var name: String
  var memo: String
}

enum CheckRowAction: Equatable {
  case checkboxTapped
}

struct CheckRowEnvironment {
  
}

let checkRowReducer = Reducer<CheckState, CheckRowAction, CheckRowEnvironment> { state, action, environment in
  switch action {
  case .checkboxTapped:
    // TODO: チェック状態の保存
    state.isChecked.toggle()
    return .none
  }
  
}
struct CheckRowView: View {
  let store: Store<CheckState, CheckRowAction>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack(alignment: .leading) {
        HStack {
          Button(action: { viewStore.send(.checkboxTapped) }) {
            Image(systemName: viewStore.isChecked ? "checkmark.square" : "square")
              .resizable()
              .frame(width: 24, height: 24)
              .padding(6)
          }
          .buttonStyle(.plain)
          
          VStack(alignment: .leading, spacing: 4) {
            Text(viewStore.check.name)
              .font(.system(size: 16))
            
            Text(viewStore.check.memo)
              .foregroundColor(.gray)
              .font(.system(size: 12))
          }
        }
        .frame(maxHeight: .infinity)
        .padding(.leading, 10)
        .padding(.trailing, 12)
        .foregroundColor(viewStore.isChecked ? .gray : nil)
        
        NavigationLink(
          destination:
            CheckDetailView(
              store: Store(
                initialState: DetailState(
                  check: viewStore.state
                ),
                reducer: detailReducer,
                environment: DetailEnvironment()
              )
            )
        ) {
          EmptyView()
        }.buttonStyle(.plain)
      }
      
    }
  }
}

struct CheckRowView_Previews: PreviewProvider {
  static var previews: some View {
    CheckRowView(
      store: Store(
        initialState:
          CheckState(
            id: UUID(),
            isChecked: false,
            check: Check(id: 0, name: "name", memo: "memo")
          ),
        reducer: checkRowReducer,
        environment: CheckRowEnvironment()
      )
    )
    }
}
