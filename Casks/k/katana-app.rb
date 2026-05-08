cask "katana-app" do
  version "1.4.4"
  sha256 "905a578cd5d2fd3ee18e521ef0e1574f19229938181585bee41008b172dc5d1e"

  url "https://github.com/bluegill/katana/releases/download/v#{version}/katana-#{version}-mac.zip"
  name "Katana"
  desc "Open-source screenshot utility"
  homepage "https://github.com/bluegill/katana/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Katana.app"

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
    "~/.katana",
    "~/Library/Application Support/Katana",
    "~/Library/Logs/Katana",
    "~/Library/Preferences/com.electron.katana.plist",
  ]

  caveats do
    requires_rosetta
  end
end
