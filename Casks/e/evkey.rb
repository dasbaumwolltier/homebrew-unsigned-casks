cask "evkey" do
  version "3.3.8"
  sha256 :no_check

  url "https://github.com/lamquangminh/EVKey/releases/download/Release/EVKeyMac.zip",
      verified: "github.com/lamquangminh/EVKey/"
  name "EVKey"
  desc "Vietnamese keyboard"
  homepage "https://evkeyvn.com/"

  livecheck do
    url :homepage
    regex(/EVKeyMac\.zip.*?v?(\d+(?:\.\d+)+)/im)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "EVKey.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Containers/com.lamquangminh.evkey",
    "~/Library/Containers/com.lamquangminh.evkeyhelper",
  ]
end
