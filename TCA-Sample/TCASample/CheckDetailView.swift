//
//  CheckDetailView.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/02/26.
//

import SwiftUI
import ComposableArchitecture

struct DetailState: Equatable {
  var confirmationDialog: ConfirmationDialogState<DetailAction>?
  var check: CheckState
  var isPresented = true
}

enum DetailAction: Equatable {
  case confirmationDialogDismissed
  case onAppear
  case titleTextFieldChanged(String)
  case memoTextChanged(String)
  case saveButtonTapped
  case typeButtonTapped
  case setType(Check.CheckType)
}

struct DetailEnvironment {
  
}

let detailReducer = Reducer<DetailState, DetailAction, DetailEnvironment> { state, action, environment in
  switch action {
  case .confirmationDialogDismissed:
    state.confirmationDialog = nil
    return .none
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
    
    state.isPresented = false
    return .none

  case .typeButtonTapped:
    state.confirmationDialog = .init(
      title: .init("タイプ"),
      buttons: [
        .cancel(.init("キャンセル")),
        .default(.init("リマインダー"), action: .send(.setType(.reminder))),
        .default(.init("Task"), action: .send(.setType(.task))),
        .default(.init("買い物"), action: .send(.setType(.buy)))
      ]
    )

    return .none

  case .setType(let type):
    // TODO: タイプ設定
    state.check.check.type = type
    return .none
  }
}

struct CheckDetailView: View {
  let store: Store<DetailState, DetailAction>
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 0) {
        TextField(
          "Title",
          text: viewStore.binding(
            get: \.check.check.name,
            send: DetailAction.titleTextFieldChanged)
        )
        .frame(height: 50)
        .padding(.horizontal, 15)
        .background(Color.orange)
        
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
        .frame(height: 200)
        .background(Color.yellow)
        .onAppear() {
          UITextView.appearance().backgroundColor = .clear
        }
        .onDisappear() {
          UITextView.appearance().backgroundColor = nil
        }

        Button(action: {
          viewStore.send(.typeButtonTapped)
        }) {
          HStack {
            Text("Type")

            Spacer()

            Text(viewStore.check.check.type.rawValue)
          }
          .foregroundColor(.black)
          .padding(.horizontal, 15)
          .frame(height: 40)
          .frame(maxWidth: .infinity)
          .background(Color.green)

        }


        Spacer()
        
      }
      .onChange(of: viewStore.isPresented) { value in
        if !value {
          presentationMode.wrappedValue.dismiss()
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
    .confirmationDialog(self.store.scope(state: \.confirmationDialog),
                        dismiss: .confirmationDialogDismissed
    )
  }
}

struct CheckDetailView_Previews: PreviewProvider {
  static var previews: some View {
    CheckDetailView(
      store: Store(
        initialState: DetailState(
          check: CheckState(
            id: UUID(),
            isChecked: false,
            check: Check(id: 0, name: "name", memo: "memo", type: .reminder)
          )
        ),
        reducer: detailReducer,
        environment: DetailEnvironment()
      )
    )
  }
}
