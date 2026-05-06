cask "mos" do
  version "4.2.0"
  sha256 "a361f871f32e763a101df29e57839188ef7fb33a289853f420fe83e9e70c008e"

  url "https://github.com/Caldis/Mos/releases/download/#{version}/Mos.Versions.#{version}.dmg",
      verified: "github.com/Caldis/Mos/"
  name "Mos"
  desc "Smooths scrolling and set mouse scroll directions independently"
  homepage "https://mos.caldis.me/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  conflicts_with cask: "mos@beta"

  app "Mos.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Preferences/com.caldis.Mos.plist"
end
