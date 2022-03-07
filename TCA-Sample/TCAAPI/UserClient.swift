//
//  UserClient.swift
//  SwiftUI-Combine-TCA
//
//  Created by shuhei.kuroda on 2022/02/24.
//

import Combine
import ComposableArchitecture

struct UserClient {
  var fetch: () -> Effect<User, ProviderError>
}

extension UserClient {
  static let live = UserClient(
    fetch: {
      Provider.shared
        .getUser()
        .eraseToEffect()
    }
  )
}

// MARK: - Mock

extension UserClient {
  static func mock(
    fetch: @escaping () -> Effect<User, ProviderError> = {
      fatalError("Unmocked")
    }
  ) -> Self {
    Self(
      fetch: fetch
    )
  }

  static func mockPreview(
    fetch: @escaping () -> Effect<User, ProviderError> = {
      .init(value: User(id: 0, name: "mock user", age: 20))
    }
  ) -> Self {
    Self(
      fetch: fetch
    )
  }
}
