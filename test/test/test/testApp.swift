//
//  testApp.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import SwiftUI

@main
struct testApp: App {
    var game = HGViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
