cask "smartdock" do
  version "2.9.0"
  sha256 "55f4c03d0725d80077bcbd04175110e4e62355e8947af5a1c97b352058ea67a2"

  url "https://github.com/alexeikaratai/smartdock/releases/download/v#{version}/SmartDock-#{version}.zip"
  name "SmartDock"
  desc "Automatically switch Dock settings when external monitor connects"
  homepage "https://github.com/alexeikaratai/smartdock"

  depends_on macos: :sonoma

  app "SmartDock.app"

  # Drop only the quarantine flag so the ad-hoc signed app opens without a
  # Gatekeeper warning. Not `-cr`: that clears every extended attribute in the
  # bundle, including ones Homebrew and Finder rely on.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/SmartDock.app"]
  end

  uninstall quit: "com.smartdock.app"

  zap trash: [
    "~/Library/Caches/com.smartdock.app",
    "~/Library/Preferences/com.smartdock.app.plist",
  ]

  caveats do
    unsigned_accessibility
  end
end
