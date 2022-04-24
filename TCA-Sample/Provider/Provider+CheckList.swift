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
//    var request = URLRequest(url: URL(string: "https://run.mocky.io/v3/803a7154-9dfc-4b43-a5c2-c1641552091b")!)
    var request = URLRequest(url: URL(string: "https://run.mocky.io/v3/ea6d3651-8d0f-465f-b5c9-cee72eb9b366")!)
    request.httpMethod = "GET"

       return requestPublisher(request)
  }
}

