//
//  User.swift
//  Combine-Practice
//
//  Created by Shuhei Kuroda on 2022/02/25.
//

import Foundation

struct User: Codable, Identifiable {
  var id: Int
  var name: String
  var age: Int
}
