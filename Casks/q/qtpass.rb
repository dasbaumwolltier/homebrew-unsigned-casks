cask "qtpass" do
  version "1.4.0"
  sha256 "cef58227b50f3eda4e4c150cb0afc7875c55c9226a91076d41e44b897629a92b"

  url "https://github.com/IJHack/qtpass/releases/download/v#{version}/qtpass-#{version}.dmg",
      verified: "github.com/IJHack/qtpass/"
  name "QtPass"
  desc "Multi-platform GUI for pass, the standard unix password manager"
  homepage "https://qtpass.org/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "QtPass.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Preferences/org.ijhack.QtPass.plist",
    "~/Library/Saved Application State/org.qtpass.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
