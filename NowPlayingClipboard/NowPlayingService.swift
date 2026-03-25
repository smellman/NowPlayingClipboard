//
//  NowPlayingService.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import AppKit
import Foundation

func registerNowPlaying() {
    MRMediaRemoteRegisterForNowPlayingNotifications(.main)
}

func getNowPlaying() async -> String? {
    return await withCheckedContinuation { continuation in
        MRMediaRemoteGetNowPlayingInfo(.main) { info in
            guard let dict = info as? [String: Any],
                  let title = dict[kMRMediaRemoteNowPlayingInfoTitle] as? String,
                  let artist = dict[kMRMediaRemoteNowPlayingInfoArtist] as? String,
                  let album = dict[kMRMediaRemoteNowPlayingInfoAlbum] as? String
            else {
                continuation.resume(returning: nil)
                return
            }
            continuation.resume(returning: "🎵 \(artist) - \(title) - \(album) #nowplaying")
        }
    }
}

func copyToClipboard(_ text: String) {
    let pb = NSPasteboard.general
    pb.clearContents()
    pb.setString(text, forType: .string)
}

func tweetViaBrowser(_ text: String) {
    let encoded = text.addingPercentEncoding(
        withAllowedCharacters: .urlQueryAllowed
    ) ?? ""
    if let url = URL(string: "https://x.com/intent/tweet?text=\(encoded)") {
        NSWorkspace.shared.open(url)
    }
}
