//
//  RealmManager.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/03/14.
//

import Foundation
import RealmSwift
import Combine

class RealmManager: ObservableObject {
  static var shared = RealmManager()
  
  private(set) var localRealm: Realm?
  @Published private(set) var tasks: [Task] = []
  
  init() {
    openRealm()
    getTasks()
  }
  
  func openRealm() {
    do {
      let config = Realm.Configuration(schemaVersion: 1
      , migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion == 1 {

        }
      })
      
      Realm.Configuration.defaultConfiguration = config
      
      localRealm = try Realm()
      
    } catch {
      print("Error opening Realm: \(error)")
    }
  }
  
  func addTask(taskTitle: String) -> Future<[Task], RealmError> {
    return Future { promise in
      if let localRealm = self.localRealm {
        do {
          try localRealm.write {
            let newTask = Task(value: ["title": taskTitle, "completed": false])
            localRealm.add(newTask)
            self.getTasks()
            promise(.success(self.tasks))
//            print("Added new task to Realm: \(newTask)")
          }
        } catch {
          promise(.failure(.addError))
//          print("Error adding task to Realm: \(error)")
        }
      }
    }
  }
  
  func getTasks() {
    if let localRealm = localRealm {
      let allTasks = localRealm.objects(Task.self).sorted(byKeyPath: "completed")
      tasks = []
      allTasks.forEach { task in
        tasks.append(task)
      }
    }
  }
  
  func updateTask(id: ObjectId, completed: Bool) -> Future<[Task], RealmError> {
    return Future { promise in
      if let localRealm = self.localRealm {
        do {
          let taskToUpdate = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
          if taskToUpdate.isEmpty {
            promise(.failure(.updateError))
          }
          
          try localRealm.write {
            taskToUpdate[0].completed = completed
            self.getTasks()
            promise(.success(self.tasks))
//            print("Updated task with id \(id)! Completed status: \(completed)")
          }
        } catch {
          promise(.failure(.updateError))
//          print("Error updating task \(id) to Realm: \(error)")
        }
      }
    }
  }
  
  func deleteTask(id: ObjectId) -> Future<[Task], RealmError> {
    return Future { promise in
      if let localRealm = self.localRealm {
        do {
          let taskToDelete = localRealm.objects(Task.self).filter(NSPredicate(format: "id == %@", id))
          if taskToDelete.isEmpty {
            promise(.failure(.deleteError))
          }
          
          try localRealm.write {
            localRealm.delete(taskToDelete)
            self.getTasks()
            promise(.success(self.tasks))
//            print("Deleted task with id \(id)")
          }
        } catch {
//          print("Error deleting task \(id) from Realm: \(error)")
          promise(.failure(.deleteError))
        }
      }
    }
  }
}

enum RealmError: Error {
  case openError
  case addError
  case getError
  case updateError
  case deleteError
}
