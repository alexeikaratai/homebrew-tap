class Smartdock < Formula
  desc "Automatically switch Dock settings when external monitor connects"
  homepage "https://github.com/alexeikaratai/smartdock"
  url "https://github.com/alexeikaratai/smartdock/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "acef51c19998435357b6d859dce73c450c2afccfd5d2088ffad865f84dc66956"
  license "MIT"

  # Xcode 26, not 16: the package declares `swift-tools-version: 6.2`, and Swift 6.2 first
  # shipped in Xcode 26. Asking for 16 let the install begin on a machine that cannot
  # finish it — `swift build` then stopped partway through with a message about tools
  # versions. Same shape as the cask installing on Intel: Homebrew accepting work it
  # cannot complete. This is the path an Intel Mac takes, so it is the path that has to
  # work; there is deliberately no `depends_on arch:` here, because `swift build` yields a
  # native binary wherever it runs.
  depends_on xcode: ["26.0", :build]
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"

    # Generate icon
    system "swift", "scripts/generate-icon.swift"

    # Build .app bundle
    app_dir = prefix/"SmartDock.app/Contents"
    (app_dir/"MacOS").mkpath
    (app_dir/"Resources").mkpath

    cp ".build/release/SmartDock", app_dir/"MacOS/SmartDock"
    cp "Resources/Info.plist", app_dir/"Info.plist"
    cp "Resources/SmartDock.entitlements", app_dir/"Resources/SmartDock.entitlements"
    cp "Resources/AppIcon.icns", app_dir/"Resources/AppIcon.icns" if File.exist?("Resources/AppIcon.icns")

    # Ad-hoc sign with entitlements (Accessibility + Apple Events)
    system "codesign", "--force", "--deep",
           "--entitlements", "Resources/SmartDock.entitlements",
           "--sign", "-",
           "#{prefix}/SmartDock.app"
  end

  def caveats
    <<~EOS
      SmartDock lives in your menu bar (no Dock icon).

      After first launch, grant Accessibility permission in:
        System Settings → Privacy & Security → Accessibility

      macOS 27 renamed that pane to "Device Control and Data Access".
      Only the wording changed; it is the same permission.

      To update SmartDock:
        brew upgrade smartdock
    EOS
  end

  test do
    assert_path_exists prefix/"SmartDock.app/Contents/MacOS/SmartDock"
  end
end
