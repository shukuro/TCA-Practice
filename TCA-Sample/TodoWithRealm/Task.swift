//
//  Task.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/14.
//

import Foundation
import RealmSwift

class Task: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var title = ""
  @Persisted var completed = false
}
