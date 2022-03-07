//
//  Provider+User.swift
//  SwiftUI-Combine-TCA
//
//  Created by shuhei.kuroda on 2022/02/24.
//

import Foundation
import Combine

extension Provider {
  func getUser() -> AnyPublisher<User, ProviderError> {
    var request = URLRequest(url: URL(string: "https://run.mocky.io/v3/de739466-7439-41cb-b9b9-514448ab26ae")!)
       request.httpMethod = "GET"

       return requestPublisher(request)
  }
}

