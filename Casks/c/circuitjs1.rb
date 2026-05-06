cask "circuitjs1" do
  # NOTE: "1" is not a version number, but an intrinsic part of the product name
  arch arm: "arm"

  version "4.1.1js"
  sha256 :no_check

  url "https://www.falstad.com/circuit/offline/CircuitJS1-mac#{arch}.dmg"
  name "Falstad CircuitJS"
  desc "Electronic circuit simulator"
  homepage "https://www.falstad.com/circuit/"

  livecheck do
    url :url
    strategy :extract_plist
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "CircuitJS1.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Preferences/com.falstad.CircuitJS1.plist",
    "~/Library/Saved Application State/com.falstad.CircuitJS1.savedState",
  ]
end
