#!/bin/bash

echo "Stopping all Owner Flutter apps..."

pkill -f "flutter run" 2>/dev/null
pkill -f "flutter_tools" 2>/dev/null

xcrun simctl terminate 2C1F3472-8ED7-4516-B3DC-14DD1481B8B9 com.jellomark.jellomarkMobileOwner 2>/dev/null
~/Library/Android/sdk/platform-tools/adb -s emulator-5556 shell am force-stop com.jellomark.jellomark_mobile_owner 2>/dev/null

echo ""
echo "All Owner Flutter apps stopped!"
echo ""
echo "Stopped devices:"
echo "  - iPhone 17 Pro"
echo "  - Android Small Phone"
