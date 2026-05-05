cask "brewlet" do
  version "1.7.4"
  sha256 "dca876a90ae80ac02dd53ccdf55322fbcac8022486c65948de10f833af1c7e6a"

  url "https://github.com/zkokaja/Brewlet/releases/download/v#{version}/Brewlet.zip"
  name "Brewlet"
  desc "Missing menulet for Homebrew"
  homepage "https://github.com/zkokaja/Brewlet"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Brewlet.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Preferences/zzada.Brewlet.plist"
end
