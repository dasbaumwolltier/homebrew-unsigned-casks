cask "lmms" do
  version "1.2.2"
  sha256 "bcf9d6693cf4000df4a4c705afb8bbaa30a3caf4e146939c983cc31eecb66eb0"

  url "https://github.com/LMMS/lmms/releases/download/v#{version}/lmms-#{version}-mac10.14.dmg",
      verified: "github.com/LMMS/lmms/"
  name "LMMS"
  desc "Music production software"
  homepage "https://lmms.io/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "LMMS.app"

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
        "~/.lmmsrc.xml",
        "~/Library/Saved Application State/io.lmms.savedState",
      ],
      rmdir: "~/Documents/lmms"

  caveats do
    requires_rosetta
  end
end
