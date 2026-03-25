# NowPlaying for macOS

NowPlaying is a simple menu bar app for macOS that shows you what's currently playing in your music player. It supports Apple Music, Spotify, and YouTube Music. maybe.

## Features

- Displays the current track's title, artist, and album.
- Copy track information to the clipboard.
- Tweet the current track directly from the menu bar.
- Without using AppleScript, it retrieves track information by communicating with `mediaremoted`, the system service that manages media playback on macOS. This allows it to work with multiple music players without needing specific integrations.

## Installation

Download this repository and open `NowPlaying.xcodeproj` in Xcode. Build and run the project to launch the app.

```bash
cd /Users/btm/develop/mac/NowPlayingClipboard/NowPlayingClipboard
xcodebuild -scheme NowPlayingClipboard -configuration Release build
pkill -f NowPlaying
cp -R ~/Library/Developer/Xcode/DerivedData/NowPlayingClipboard-*/Build/Products/Release/NowPlayingClipboard.app /Applications/NowPlaying.app
open /Applications/NowPlaying.app
```

## Notes

- This app's identifier is 'com.apple.nowplaying', to pass `mediaremoted`'s check for Apple Music. However, this is not an official Apple app and may not work with all features of Apple Music or other music players. 

## License

MIT License.

## Author

- Taro Matsuzawa

## Co-author

- Claude Code