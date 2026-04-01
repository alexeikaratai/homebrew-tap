cask "smartdock" do
  version "1.5.0"
  sha256 "c0463ed1ce35c2c9bfd3387556fc1693f22c64664a27d57620ba325bee8ed912"

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
