cask "weektodo" do
  version "2.2.0"
  sha256 "2b5c2c9ed1a16776fc7121d37f4ccaf40a82d94987906f5b2e75e428acda2167"

  url "https://github.com/Zuntek/WeekToDoWeb/releases/download/v#{version}/WeekToDo-#{version}.dmg",
      verified: "github.com/Zuntek/WeekToDoWeb/"
  name "WeekToDo"
  desc "Weekly planner app focused on privacy"
  homepage "https://weektodo.me/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "WeekToDo.app"

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
    "~/Library/Application Support/WeekToDo",
    "~/Library/Preferences/weektodo-app.netlify.app.plist",
    "~/Library/Saved Application State/weektodo-app.netlify.app.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
