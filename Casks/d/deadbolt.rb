cask "deadbolt" do
  arch arm: "-arm64"

  version "2.0.2"
  sha256 arm:   "d5ede4239f0474124bfa11310938d5657d1fc6d550b32fabe1672506ca6e60a7",
         intel: "7ef2584d67b102944da8ec823811488b6a4137f83a4ff8c30d50685e996385f7"

  url "https://github.com/alichtman/deadbolt/releases/download/v#{version}/Deadbolt-#{version}#{arch}.dmg"
  name "Deadbolt"
  desc "File encryption tool"
  homepage "https://github.com/alichtman/deadbolt"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Deadbolt.app"

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
    "~/Library/Application Support/deadbolt",
    "~/Library/Preferences/org.alichtman.deadbolt.plist",
    "~/Library/Saved Application State/org.alichtman.deadbolt.savedState",
  ]
end
