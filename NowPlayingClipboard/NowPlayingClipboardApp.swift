//
//  NowPlayingClipboardApp.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import SwiftUI

@main
struct NowPlayingClipboardApp: App {
    @State private var statusText = "No track"

    init() {
        registerNowPlaying()
        setupHotkeys()
    }

    var body: some Scene {
        MenuBarExtra("NowPlaying", systemImage: "music.note") {
            MenuBarView(statusText: $statusText)
        }
    }

    private func setupHotkeys() {
        let manager = HotkeyManager.shared
        manager.onCopy = {
            Task { @MainActor in
                if let text = await getNowPlaying() {
                    copyToClipboard(text)
                    statusText = text
                } else {
                    statusText = "Nothing playing"
                }
            }
        }
        manager.onTweet = {
            Task { @MainActor in
                if let text = await getNowPlaying() {
                    tweetViaBrowser(text)
                    statusText = text
                }
            }
        }
        manager.register()
    }
}
