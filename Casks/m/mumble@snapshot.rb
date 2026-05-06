cask "mumble@snapshot" do
  version "1.6.870"
  sha256 "d5e0f164e8f63ce79b0c2bc9d1e059213d80c3c5cd9e28c065657bc0594495ea"

  url "https://dl.mumble.info/snapshot/mumble_client-#{version}.x64.dmg"
  name "Mumble Snapshot"
  desc "Open-source, low-latency, high quality voice chat software for gaming"
  homepage "https://mumble.info/"

  livecheck do
    url "https://dl.mumble.info/latest/snapshot/client-macos-x64"
    strategy :header_match
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  conflicts_with cask: "mumble"

  app "Mumble.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "/Library/ScriptingAdditions/MumbleOverlay.osax",
    "~/Library/Application Support/Mumble",
    "~/Library/Logs/Mumble.log",
    "~/Library/Preferences/net.sourceforge.mumble.Mumble.plist",
    "~/Library/Saved Application State/net.sourceforge.mumble.Mumble.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
