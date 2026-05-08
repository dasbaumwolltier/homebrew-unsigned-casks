cask "stremioservice" do
  version "0.1.21"
  sha256 "e74fe7a085e7462abfefcd050e09ac053342ce37a062f9878f24f0d459b60414"

  url "https://github.com/Stremio/stremio-service/releases/download/v#{version}/StremioService.dmg",
      verified: "github.com/Stremio/stremio-service/"
  name "Stremio Service"
  desc "Companion app for Stremio Web"
  homepage "https://web.strem.io/"

  livecheck do
    url "https://www.stremio.com/updater/check?product=stremio-service"
    strategy :json do |json|
      json["version"]
    end
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64

  app "StremioService.app"

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

  uninstall launchctl: "com.stremio.service"

  zap trash: [
    "~/Library/Application Support/stremio-server",
    "~/Library/LaunchAgents/com.stremio.service.plist",
  ]
end
