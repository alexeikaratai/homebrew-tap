cask "smartdock" do
  version "3.0.1"
  sha256 "8cf866596953bbd15fad92c852afe2936a8e54c303d1bd6c06f7d4fe1060c8a9"

  url "https://github.com/alexeikaratai/smartdock/releases/download/v#{version}/SmartDock-#{version}.zip"
  name "SmartDock"
  desc "Automatically switch Dock settings when external monitor connects"
  homepage "https://github.com/alexeikaratai/smartdock"

  depends_on macos: :sonoma
  # The zip carries one architecture. `release.yml` builds on a macos-26 runner, which
  # is arm64, and `lipo -archs` on the shipped binary reports arm64 alone — so on an
  # Intel Mac this cask used to install happily and produce an app that would not open.
  # Homebrew refuses the install instead now, and says why.
  #
  # The **formula** has no such line on purpose: it runs `swift build` from source and
  # produces a native binary wherever it is run, Intel included.
  depends_on arch: :arm64

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
