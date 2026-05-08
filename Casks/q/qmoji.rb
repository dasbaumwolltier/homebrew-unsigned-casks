cask "qmoji" do
  version "1.3.1"
  sha256 "dbe2d6de7bbbba3160434d8638fdccb2cfa192ecd7cbb4e5d573df74e9f740c5"

  url "https://github.com/jaredly/qmoji/releases/download/#{version}/qmoji.zip"
  name "qmoji"
  desc "Like mojibar, but written in reasonml"
  homepage "https://github.com/jaredly/qmoji"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "qmoji.app"

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

  zap trash: "~/Library/Preferences/com.jaredforsyth.qmoji.json"

  caveats do
    requires_rosetta
  end
end
