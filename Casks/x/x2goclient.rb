cask "x2goclient" do
  version "4.1.2.2"
  sha256 :no_check

  url "https://code.x2go.org/releases/X2GoClient_latest_macosx_10_13.dmg"
  name "X2Go Client"
  desc "Remote desktop software"
  homepage "https://wiki.x2go.org/doku.php"

  livecheck do
    url "https://wiki.x2go.org/doku.php/doc:release-notes-mswin"
    regex(/x2goclient[._-]v?(\d+(?:\.\d+)+)/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "x2goclient.app"

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
    "~/.x2go",
    "~/.x2goclient",
    "~/Library/Application Support/CrashReporter/x2goclient_*.plist",
    "~/Library/Preferences/x2goclient.plist",
  ]

  caveats do
    requires_rosetta
  end
end
