cask "syncplay" do
  version "1.7.5"
  sha256 "3933a2011071b736d5acbd68111c1abd19a78135136661201918ea4596ade871"

  url "https://github.com/Syncplay/syncplay/releases/download/v#{version}/Syncplay_#{version}.dmg",
      verified: "github.com/Syncplay/syncplay/"
  name "Syncplay"
  desc "Synchronises media players"
  homepage "https://syncplay.pl/"

  livecheck do
    url :homepage
    regex(/href=.*?Syncplay[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Syncplay.app"

  postflight do |c|
    app_artifacts = c.cask.artifacts.select do |artifact|
      artifact.respond_to?(:target) && artifact.target.to_s.end_with?(".app")
    end

    app_artifacts.each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/.syncplay",
    "~/Library/Preferences/com.syncplay.Interface.plist",
    "~/Library/Preferences/com.syncplay.MainWindow.plist",
    "~/Library/Preferences/com.syncplay.MoreSettings.plist",
    "~/Library/Preferences/com.syncplay.PlayerList.plist",
    "~/Library/Preferences/pl.syncplay.Syncplay.plist",
    "~/Library/Saved Application State/pl.syncplay.Syncplay.savedState",
  ]
end
