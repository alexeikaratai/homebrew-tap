cask "smartdock" do
  version "2.5.7"
  sha256 "b76bff4fa9390af0ace9da7fb01b676a730bf89ae832d1e702550a5c3a2c5ab9"

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
