//
//  NowPlayingService.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import AppKit
import Foundation

private let handle = dlopen(
    "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote",
    RTLD_NOW
)

private typealias GetNowPlayingInfoFunc =
    @convention(c) (DispatchQueue, @escaping (CFDictionary) -> Void) -> Void

private typealias RegisterForNowPlayingNotificationsFunc =
    @convention(c) (DispatchQueue) -> Void

private let MRGetNowPlaying: GetNowPlayingInfoFunc? = {
    guard let handle,
          let sym = dlsym(handle, "MRMediaRemoteGetNowPlayingInfo")
    else { return nil }
    return unsafeBitCast(sym, to: GetNowPlayingInfoFunc.self)
}()

private let MRRegisterForNowPlayingNotifications: RegisterForNowPlayingNotificationsFunc? = {
    guard let handle,
          let sym = dlsym(handle, "MRMediaRemoteRegisterForNowPlayingNotifications")
    else { return nil }
    return unsafeBitCast(sym, to: RegisterForNowPlayingNotificationsFunc.self)
}()

func registerNowPlaying() {
    MRRegisterForNowPlayingNotifications?(.main)
}

func getNowPlaying() async -> String? {
    guard let MRGetNowPlaying else { return nil }
    return await withCheckedContinuation { continuation in
        MRGetNowPlaying(.main) { info in
            let dict = info as NSDictionary
            guard let title = dict["kMRMediaRemoteNowPlayingInfoTitle"] as? String,
                  let artist = dict["kMRMediaRemoteNowPlayingInfoArtist"] as? String,
                  let album = dict["kMRMediaRemoteNowPlayingInfoAlbum"] as? String
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
