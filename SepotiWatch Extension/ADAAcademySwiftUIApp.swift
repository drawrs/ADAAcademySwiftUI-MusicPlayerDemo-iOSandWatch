//
//  ADAAcademySwiftUIApp.swift
//  SepotiWatch Extension
//
//  Created by Rizal Hilman on 21/08/21.
//

import SwiftUI

@main
struct ADAAcademySwiftUIApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
