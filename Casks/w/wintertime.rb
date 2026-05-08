cask "wintertime" do
  version "0.0.7"
  sha256 "b7cb5b25172e3450982d673533931e721e009677e711fffa320b5e42abee3ff3"

  url "https://github.com/actuallymentor/wintertime-mac-background-freezer/releases/download/#{version}/Wintertime-#{version}.dmg"
  name "Wintertime"
  desc "Utility to freeze apps running in the background to save battery"
  homepage "https://github.com/actuallymentor/wintertime-mac-background-freezer"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Wintertime.app"

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
    "~/Library/Application Support/Wintertime",
    "~/Library/Logs/Wintertime",
    "~/Library/Preferences/com.electron.wintertime.plist",
    "~/Library/Saved Application State/com.electron.wintertime.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
