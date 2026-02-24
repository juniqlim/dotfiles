#!/bin/bash

# iTerm2 Default Profile 설정
# defaults 명령어로 기본 프로필(첫 번째 프로필)의 설정을 변경

PLIST="com.googlecode.iterm2"

# PlistBuddy로 기본 프로필(index 0) 설정
BUDDY="/usr/libexec/PlistBuddy"
PLIST_PATH="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

# 폰트 설정
$BUDDY -c "Set ':New Bookmarks:0:Normal Font' 'FiraCodeNFM-Ret 16'" "$PLIST_PATH"
$BUDDY -c "Set ':New Bookmarks:0:Non Ascii Font' 'D2CodingLigatureNFM-Bold 16'" "$PLIST_PATH"
$BUDDY -c "Set ':New Bookmarks:0:Use Non-ASCII Font' true" "$PLIST_PATH"

# 새 탭에서 이전 디렉터리 유지
$BUDDY -c "Set ':New Bookmarks:0:Custom Directory' 'Recycle'" "$PLIST_PATH"

# Thin Strokes: 0=Never
defaults write "$PLIST" AppleFontSmoothing -int 0

echo "iTerm2 settings applied. Restart iTerm2 to take effect."
