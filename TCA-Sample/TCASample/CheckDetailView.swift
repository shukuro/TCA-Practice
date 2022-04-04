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
  case titleTextFieldChanged(String)
  case memoTextChanged(String)
  case saveButtonTapped
}

struct DetailEnvironment {
  
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .none
  case .titleTextFieldChanged(let name):
    state.check.check.name = name
    return .none
  case .memoTextChanged(let memo):
    state.check.check.memo = memo
    return .none
  case .saveButtonTapped:
    // TODO: 保存処理
    return .none
  }
}

struct CheckDetailView: View {
  let store: Store<DetailState, DetailAction>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        TextField(
          "Title",
          text: viewStore.binding(
            get: \.check.check.name,
            send: DetailAction.titleTextFieldChanged)
        )
        .frame(height: 50)
        .padding(.horizontal, 15)
        .background(Color.white)
        
        ZStack(alignment: .topLeading) {
          if viewStore.check.check.memo.isEmpty {
            HStack {
              Text("メモ")
                .opacity(0.25)
                .padding(.leading, 15)
                .padding(.top, 8)
                
            }
          }
          
          TextEditor(
            text: viewStore.binding(
              get: \.check.check.memo,
              send: DetailAction.memoTextChanged
            )
          )
          .lineLimit(nil)
          .padding(.horizontal, 10)
        }
        .background(Color.yellow)
        .onAppear() {
          UITextView.appearance().backgroundColor = .clear
        }
        .onDisappear() {
          UITextView.appearance().backgroundColor = nil
        }
        
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
      .navigationTitle("詳細")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            viewStore.send(.saveButtonTapped)
          }
          ) {
            Text("保存")
          }
        }
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
