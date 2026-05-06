cask "pomotroid" do
  version "1.7.0"
  sha256 "fab1a8598490db267639609b42312a8947ee2de075164935d0eba60c57790788"

  url "https://github.com/Splode/pomotroid/releases/download/v#{version}/pomotroid-#{version}-macos.dmg"
  name "Pomotroid"
  desc "Timer application"
  homepage "https://github.com/Splode/pomotroid"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Pomotroid.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/pomotroid",
    "~/Library/Preferences/com.splode.pomotroid.plist",
    "~/Library/Saved Application State/com.splode.pomotroid.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
