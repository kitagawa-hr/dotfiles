#! /bin/bash -e

# macOS settings
# For detail, see links below.
# - https://macos-defaults.com/#%F0%9F%99%8B-what-s-a-defaults-command
# - https://ottan.jp/posts/2016/07/system-preferences-terminal-defaults-mission-control/

# Dock
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock persistent-apps -array
defaults delete com.apple.dock wvous-br-corner

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder AppleShowAllFiles YES
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Miscellaneous
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 6
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

killall Finder
killall Dock
killall SystemUIServer
