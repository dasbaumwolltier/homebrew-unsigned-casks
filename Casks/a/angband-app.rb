cask "angband-app" do
  version "4.2.6"
  sha256 "f212c035b707db0d7e019030aff2cdbca5cc9108226567675e4ebe67c6412792"

  url "https://github.com/angband/angband/releases/download/#{version}/Angband-#{version}-osx.dmg",
      verified: "github.com/angband/angband/"
  name "Angband"
  desc "Dungeon exploration game"
  homepage "https://angband.github.io/angband/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "Angband.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Documents/Angband",
    "~/Library/Preferences/org.rephial.angband.plist",
    "~/Library/Saved Application State/org.rephial.angband.savedState",
  ]
end
