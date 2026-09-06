cask "smartdock" do
  version "2.5.6"
  sha256 "e0d21559f76102f1d9ed1484d9cd874e0ac60c4038e4b504b137266f3214f62c"

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
