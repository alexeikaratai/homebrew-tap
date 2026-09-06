class Smartdock < Formula
  desc "Automatically switch Dock settings when external monitor connects"
  homepage "https://github.com/alexeikaratai/smartdock"
  url "https://github.com/alexeikaratai/smartdock/archive/refs/tags/v2.5.7.tar.gz"
  sha256 "c0b78635ff0c66c920a3d791e888a5f3f606ccd17f912bd6c25c702d888d2f9f"
  license :cannot_represent

  depends_on xcode: ["16.0", :build]
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

      To update SmartDock:
        brew upgrade smartdock
    EOS
  end

  test do
    assert_path_exists prefix/"SmartDock.app/Contents/MacOS/SmartDock"
  end
end
