cask "betterdiscord-installer" do
  version "1.3.0"
  sha256 "85bdd7b44f9624f7740af4d26682f21730c47a643fde009f2ad766afa19356b8"

  url "https://github.com/BetterDiscord/Installer/releases/download/v#{version}/BetterDiscord-Mac.zip",
      verified: "github.com/BetterDiscord/Installer/"
  name "BetterDiscord"
  desc "Installer for BetterDiscord"
  homepage "https://betterdiscord.app/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on cask: "discord"

  app "BetterDiscord.app"

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
    "~/Library/Application Support/BetterDiscord Installer",
    "~/Library/Application Support/BetterDiscord",
    "~/Library/Preferences/app.betterdiscord.installer.plist",
    "~/Library/Saved Application State/app.betterdiscord.installer.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
