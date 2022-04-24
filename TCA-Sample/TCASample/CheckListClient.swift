//
//  CheckListClient.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/03/03.
//

import Combine
import ComposableArchitecture

struct CheckListClient {
  var fetch: () -> Effect<[Check], ProviderError>
}

extension CheckListClient {
  static let live = CheckListClient(
    fetch: {
      Provider.shared
        .getCheckList()
        .eraseToEffect()
    }
  )
}

// MARK: - Mock

extension CheckListClient {
  static func mock(
    fetch: @escaping () -> Effect<[Check], ProviderError> = {
      fatalError("Unmocked")
    }
  ) -> Self {
    Self(
      fetch: fetch
    )
  }

  static func mockPreview(
    fetch: @escaping () -> Effect<[Check], ProviderError> = {
      .init(value: [Check(id: 0, name: "mock data", memo: "mockmock", type: .reminder)])
    }
  ) -> Self {
    Self(
      fetch: fetch
    )
  }
}
