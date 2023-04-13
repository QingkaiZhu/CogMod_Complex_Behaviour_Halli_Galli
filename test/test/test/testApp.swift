//
//  testApp.swift
//  test
//
//  Created by P. Pintea on 2/15/23.
//

import SwiftUI

@main
struct testApp: App {
    @State private var isHardLevel: Bool = false

    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}

