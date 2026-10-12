cask "smarttype" do
  version "0.1.0"
  sha256 "8906759bd01995019f8975a7939d60116597dc990f2d7cf2141deaad5ad51873"

  url "https://github.com/alexeikaratai/smarttype/releases/download/v#{version}/SmartType-#{version}.zip"
  name "SmartType"
  desc "Fix text typed in the wrong keyboard layout and translate selections"
  homepage "https://github.com/alexeikaratai/smarttype"

  # The release is built on Apple silicon only; an Intel Mac could not open it.
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "SmartType.app"

  # Drop only the quarantine flag so the ad-hoc signed app opens without a
  # Gatekeeper warning. Not `-cr`: that clears every extended attribute in the
  # bundle, including ones Homebrew and Finder rely on.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/SmartType.app"]
  end

  uninstall quit: "com.smarttype.app"

  zap trash: "~/Library/Preferences/com.smarttype.app.plist"

  caveats <<~EOS
    SmartType needs Accessibility to read and replace the selected text.
    Choose "Grant Access…" in its menu bar menu: SmartType restarts and opens
    the list in System Settings, where you switch it on.

    SmartType is ad-hoc signed, so macOS drops the permission with every
    update; the same button gives it back.
  EOS
end
