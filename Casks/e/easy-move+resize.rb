cask "easy-move+resize" do
  version "1.8.1"
  sha256 "c8a93e5917f13ea1dd474e6fb0f2f8a5333202d74fa4e05f711c08fd9af38eb9"

  url "https://github.com/dmarcotte/easy-move-resize/releases/download/#{version}/Easy.Move+Resize.app.zip"
  name "Easy Move+Resize"
  desc "Utility to support moving and resizing using a modifier key and mouse drag"
  homepage "https://github.com/dmarcotte/easy-move-resize"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Easy Move+Resize.app"

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

  zap trash: "~/Library/Preferences/org.dmarcotte.Easy-Move-Resize.plist"
end
