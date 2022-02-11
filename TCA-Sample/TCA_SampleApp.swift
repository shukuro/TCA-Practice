//
//  TCA_SampleApp.swift
//  TCA-Sample
//
//  Created by Shuhei Kuroda on 2022/02/06.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_SampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: AppState(),
                    reducer: appReducer,
                    environment: AppEnvironment(
                      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                      uuid: UUID.init)
                )
            )
        }
    }
}
