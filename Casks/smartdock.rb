cask "smartdock" do
  version "1.6.0"
  sha256 "d0fd1e18657a94f45bf8d80a931ab5ce196cf45dcd10952ec01cecf15d8139b5"

  url "https://github.com/alexeikaratai/smartdock/releases/download/v#{version}/SmartDock-#{version}.zip"
  name "SmartDock"
  desc "Automatically switch Dock settings when external monitor connects"
  homepage "https://github.com/alexeikaratai/smartdock"

  depends_on macos: ">= :sonoma"

  app "SmartDock.app"

  postflight do
    # Remove quarantine so unsigned app opens without Gatekeeper warnings
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/SmartDock.app"]

    ohai "SmartDock needs Accessibility permission to control the Dock."
    ohai "Grant it in: System Settings → Privacy & Security → Accessibility"
  end

  uninstall quit: "com.smartdock.app"

  zap trash: [
    "~/Library/Preferences/com.smartdock.app.plist",
    "~/Library/Caches/com.smartdock.app",
  ]
end
