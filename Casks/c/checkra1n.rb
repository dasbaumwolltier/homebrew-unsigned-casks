cask "checkra1n" do
  version "0.12.4"
  sha256 "754bb6ec4747b2e700f01307315da8c9c32c8b5816d0fe1e91d1bdfc298fe07b"

  url "https://checkra.in/assets/downloads/macos/#{sha256}/checkra1n%20beta%20#{version}.dmg"
  name "checkra1n"
  desc "Jailbreak for iPhone 5s through iPhone X, iOS 12.0 and up"
  homepage "https://checkra.in/"

  livecheck do
    url :homepage
    regex(%r{href=.*?/checkra1n%20beta%20(\d+(?:\.\d+)+)\.dmg}i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "checkra1n.app"
  binary "#{appdir}/checkra1n.app/Contents/MacOS/checkra1n"

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

  # No zap stanza required

  caveats do
    requires_rosetta
  end
end
