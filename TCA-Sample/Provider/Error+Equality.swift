//
//  Error+Equality.swift
//  SwiftUI-Combine-TCA
//
//  Created by shuhei.kuroda on 2022/02/24.
//

import Foundation

/**
 # Inspired by:
 https://kandelvijaya.com/2018/04/21/blog_equalityonerror/
 */
class ErrorUtility {
  public static func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
    return lhs.reflectedString == rhs.reflectedString
  }
}

public extension Error {
  var reflectedString: String {
    return String(reflecting: self)
  }

  func isEqual(to: Self) -> Bool {
    return reflectedString == to.reflectedString
  }
}

public extension NSError {
  func isEqual(to: NSError) -> Bool {
    let lhs = self as Error
    let rhs = to as Error
    return isEqual(to) && lhs.reflectedString == rhs.reflectedString
  }
}

