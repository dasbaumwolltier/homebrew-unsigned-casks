cask "weakauras-companion" do
  version "5.3.1"
  sha256 "bc430a4d29679c9e446dfe1c215596a307438cb66b885ce637b4c3b22b1fd990"

  url "https://github.com/WeakAuras/WeakAuras-Companion/releases/download/v#{version}/WeakAuras-Companion-#{version}-mac-universal.dmg"
  name "WeakAuras Companion"
  desc "Update your auras from Wago.io and creates regular backups of them"
  homepage "https://github.com/WeakAuras/WeakAuras-Companion/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :monterey"

  app "WeakAuras Companion.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/weakauras-companion",
    "~/Library/Logs/weakauras-companion",
    "~/Library/Preferences/wtf.weakauras.companion.plist",
  ]
end
