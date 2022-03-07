//
//  Provider+CheckList.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/03/03.
//

import Foundation
import Combine

extension Provider {
  func getCheckList() -> AnyPublisher<[Check], ProviderError> {
    var request = URLRequest(url: URL(string: "https://run.mocky.io/v3/803a7154-9dfc-4b43-a5c2-c1641552091b")!)
       request.httpMethod = "GET"

       return requestPublisher(request)
  }
}

