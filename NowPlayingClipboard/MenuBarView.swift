//
//  MenuBarView.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import SwiftUI
import AppKit

struct MenuBarView: View {
    @State private var statusText = "No track"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(statusText)
                .font(.headline)
                .padding(.horizontal)
            
            Divider()
            
            Button("📋 Copy Now Playing") {
                Task {
                    if let text = await getNowPlaying() {
                        copyToClipboard(text)
                        statusText = text
                    } else {
                        statusText = "Nothing playing"
                    }
                }
            }
            .keyboardShortcut("i", modifiers: [.command, .shift])
            
            Button("🐦 Tweet via Browser") {
                Task {
                    if let text = await getNowPlaying() {
                        tweetViaBrowser(text)
                        statusText = text
                    }
                }
            }
            .keyboardShortcut("t", modifiers: [.command, .shift])
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            
        }
        .padding(.vertical, 8)
    }
}
