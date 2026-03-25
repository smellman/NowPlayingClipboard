//
//  HotkeyManager.swift
//  NowPlayingClipboard
//
//  Created by 松澤太郎 on 2026/03/25.
//

import AppKit
import Carbon

final class HotkeyManager {
    static let shared = HotkeyManager()

    private var eventHotKeys: [EventHotKeyRef?] = []
    var onCopy: (() -> Void)?
    var onTweet: (() -> Void)?

    private init() {}

    func register() {
        var gEventSpec = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        InstallEventHandler(
            GetApplicationEventTarget(),
            hotKeyHandler,
            1, &gEventSpec, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()), nil
        )

        // Cmd+Shift+I -> Copy
        registerHotKey(id: 1, keyCode: UInt32(kVK_ANSI_I), modifiers: UInt32(cmdKey | shiftKey))
        // Cmd+Shift+T -> Tweet
        registerHotKey(id: 2, keyCode: UInt32(kVK_ANSI_T), modifiers: UInt32(cmdKey | shiftKey))
    }

    private func registerHotKey(id: UInt32, keyCode: UInt32, modifiers: UInt32) {
        var hotKeyID = EventHotKeyID(signature: OSType(0x4E50_434C), id: id) // "NPCL"
        var hotKeyRef: EventHotKeyRef?
        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        eventHotKeys.append(hotKeyRef)
    }

    fileprivate func handleHotKey(id: UInt32) {
        switch id {
        case 1: onCopy?()
        case 2: onTweet?()
        default: break
        }
    }
}

private func hotKeyHandler(
    nextHandler: EventHandlerCallRef?,
    event: EventRef?,
    userData: UnsafeMutableRawPointer?
) -> OSStatus {
    guard let event, let userData else { return OSStatus(eventNotHandledErr) }
    var hotKeyID = EventHotKeyID()
    GetEventParameter(
        event,
        UInt32(kEventParamDirectObject),
        UInt32(typeEventHotKeyID),
        nil,
        MemoryLayout<EventHotKeyID>.size,
        nil,
        &hotKeyID
    )
    let manager = Unmanaged<HotkeyManager>.fromOpaque(userData).takeUnretainedValue()
    manager.handleHotKey(id: hotKeyID.id)
    return noErr
}
