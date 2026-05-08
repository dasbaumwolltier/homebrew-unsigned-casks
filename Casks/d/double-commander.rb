cask "double-commander" do
  arch arm: "aarch64", intel: "x86_64"

  version "1.1.32"
  sha256 arm:   "dfbf339a2ef78e2346ad2a874a9961f5b725c2a8d8b32c33bc7751348488792b",
         intel: "f2b39a06bcd4da63768db3f21cc36395223b9b289671479439adb6f66c594c15"

  url "https://github.com/doublecmd/doublecmd/releases/download/v#{version}/doublecmd-#{version}.cocoa.#{arch}.dmg",
      verified: "github.com/doublecmd/doublecmd/releases/"
  name "Double Commander"
  desc "File manager with two panels"
  homepage "https://doublecmd.sourceforge.io/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "Double Commander.app"

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

  zap trash: "~/Library/Caches/doublecmd"
end
