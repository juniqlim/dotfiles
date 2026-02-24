#!/bin/bash

# iTerm2 설정 import
# - profile.json을 Dynamic Profiles 디렉토리에 복사
# - iTerm2 실행 중에도 바로 반영됨
# - 프로필 설정 변경은 profile.json 수정 후 이 스크립트 재실행
# - 적용 후 Cmd+O에서 "juniq" 프로필 선택
# - 기본 프로필로 설정: Preferences > Profiles > juniq > Other Actions > Set as Default

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DYNAMIC_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"

mkdir -p "$DYNAMIC_PROFILES_DIR"
cp "$SCRIPT_DIR/profile.json" "$DYNAMIC_PROFILES_DIR/profile.json"

# Thin Strokes: 0=Never
defaults write com.googlecode.iterm2 AppleFontSmoothing -int 0

# Theme: 5=Minimal (타이틀바가 배경색과 동일해짐)
defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption -int 5

# iTerm2만 다크 모드 강제 (탭 글자가 밝게 표시됨)
defaults write com.googlecode.iterm2 NSRequiresAquaSystemAppearance -bool false

# 탭 1개일 때 탭바 숨기기
defaults write com.googlecode.iterm2 HideTab -bool true

# 이전 세션 복원 (종료 전 작업 디렉터리 유지)
defaults write com.googlecode.iterm2 NSQuitAlwaysKeepsWindows -bool true

echo "iTerm2 settings applied."
