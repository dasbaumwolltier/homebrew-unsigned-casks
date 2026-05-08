cask "pusher" do
  version "0.7.5"
  sha256 "b329a5106b6670bf50da4b91ba34d82102edb70074828cf4d0cd879b1a5e2180"

  url "https://github.com/noodlewerk/NWPusher/releases/download/#{version}/pusher.app.zip"
  name "NWPusher"
  desc "Send push notifications through Apple Push Notification Service"
  homepage "https://github.com/noodlewerk/NWPusher"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Pusher.app"

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
    "~/Library/Pusher",
    "~/Library/Saved Application State/com.noodlewerk.Pusher.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
