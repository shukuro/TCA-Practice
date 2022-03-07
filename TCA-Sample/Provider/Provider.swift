//
//  Provider.swift
//  SwiftUI-Combine-TCA
//
//  Created by shuhei.kuroda on 2022/02/24.
//

import Foundation
import Combine

class Provider {
  static var shared = Provider()
  
  func requestPublisher<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, ProviderError> {
    URLSession.shared.dataTaskPublisher(for: request)
      .mapError { .network(error: $0) }
      .flatMap { self.requestDecoder(data: $0.data) }
      .eraseToAnyPublisher()
  }
}

extension Provider {
  private func requestDecoder<T: Codable>(data: Data) -> AnyPublisher<T, ProviderError> {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return Just(data)
      .tryMap { try decoder.decode(T.self, from: $0) }
      .mapError { .decoding(error: $0) }
      .eraseToAnyPublisher()
  }

  func requestEncoder<T: Codable>(data: T) -> AnyPublisher<Data, ProviderError> {
    return Just(data)
      .tryMap { try JSONEncoder().encode($0) }
      .mapError { .encoding(error: $0) }
      .eraseToAnyPublisher()
  }
}
