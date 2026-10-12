class Smarttype < Formula
  desc "Fix text typed in the wrong keyboard layout and translate selections"
  homepage "https://github.com/alexeikaratai/smarttype"
  url "https://github.com/alexeikaratai/smarttype/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"
  license "MIT"

  # macOS 26's SDK, for Liquid Glass and the translation API; Xcode's xcstringstool,
  # for the Russian strings.
  depends_on xcode: ["26.0", :build]
  depends_on macos: :sonoma

  def install
    # The developer's own `make app`, so the bundle cannot drift from it: the binary, the
    # icon, the Russian strings and the Services titles, ad-hoc signed. SwiftPM's sandbox
    # cannot run inside Homebrew's.
    system "make", "app", "SWIFT_BUILD_FLAGS=--disable-sandbox"
    prefix.install "build/SmartType.app"
  end

  def caveats
    <<~EOS
      SmartType lives in the menu bar. Start it with:
        open #{opt_prefix}/SmartType.app

      It needs Accessibility to read and replace the selected text: choose
      "Grant Access…" in its menu, then switch SmartType on in System Settings.
      Every build is ad-hoc signed, so macOS drops the permission after each
      upgrade; the same button gives it back.
    EOS
  end

  test do
    assert_path_exists prefix/"SmartType.app/Contents/MacOS/SmartType"
  end
end
