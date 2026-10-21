cask "smartdock" do
  version "3.0.1"
  sha256 "8cf866596953bbd15fad92c852afe2936a8e54c303d1bd6c06f7d4fe1060c8a9"

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
