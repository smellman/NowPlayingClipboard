//
//  MenuBarView.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import AppKit
import SwiftUI

struct MenuBarView: View {
    @Binding var statusText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(statusText)
                .font(.headline)
                .padding(.horizontal)

            Divider()

            Button("📋 Copy Now Playing (⌘⇧I)") {
                Task {
                    if let text = await getNowPlaying() {
                        copyToClipboard(text)
                        statusText = text
                    } else {
                        statusText = "Nothing playing"
                    }
                }
            }

            Button("🐦 Tweet via Browser (⌘⇧T)") {
                Task {
                    if let text = await getNowPlaying() {
                        tweetViaBrowser(text)
                        statusText = text
                    }
                }
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(.vertical, 8)
    }
}
