cask "warsow" do
  version "2.1.2"
  sha256 "176b037186e4d8a1c0fc740fe8660cd960339fc4eeca5e5eaaec4028b9bd6aba"

  url "https://warsow.net/warsow-#{version}.dmg"
  name "Warsow"
  desc "First-person shooter game"
  homepage "https://www.warsow.net/"

  livecheck do
    url "https://www.warsow.net/bundles/client.bundle.js"
    regex(%r{href=.*?/warsow-(\d+(?:\.\d+)*)\.dmg}i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Warsow.app"

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
    "~/Library/Application Support/Warsow-#{version.major_minor}",
    "~/Library/Caches/Warsow-#{version.major_minor}",
    "~/Library/Saved Application State/org.picmip.Warsow.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
