cask "dogecoin" do
  version "1.14.9"
  sha256 "c87c956834a87da8200274a097364c986ccca045d71ce92d0f7d407129d25a83"

  url "https://github.com/dogecoin/dogecoin/releases/download/v#{version}/dogecoin-#{version}-osx-unsigned.dmg",
      verified: "github.com/dogecoin/dogecoin/"
  name "Dogecoin"
  desc "Cryptocurrency"
  homepage "https://dogecoin.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Dogecoin-Qt.app"

  preflight do
    set_permissions "#{staged_path}/Dogecoin-Qt.app", "0755"
  end

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/com.dogecoin.Dogecoin-Qt.plist"

  caveats do
    requires_rosetta
  end
end
