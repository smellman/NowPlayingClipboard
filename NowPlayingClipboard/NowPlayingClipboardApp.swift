//
//  NowPlayingClipboardApp.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import SwiftUI

@main
struct NowPlayingClipboardApp: App {
    init() {
        registerNowPlaying()
    }

    var body: some Scene {
        MenuBarExtra("NowPlaying", systemImage: "music.note") {
            MenuBarView()
        }
    }
}
