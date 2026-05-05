cask "wormhole" do
  version "1.8.0"
  sha256 :no_check

  url "https://drive.usercontent.google.com/download?id=1T6sPiSkIcuMoJwY2HS2F8j0QpLiX4oKB&export=download&confirm=t",
      verified: "drive.usercontent.google.com/download?id=1T6sPiSkIcuMoJwY2HS2F8j0QpLiX4oKB&export=download&confirm=t"
  name "Wormhole"
  desc "Browse & Control phone on PC, Screen Fusion for iOS & Android"
  homepage "https://er.run/"

  livecheck do
    url "https://er.run/release"
    regex(/<div[^>]*class=["']?version[^>]*>\s*<div[^>]*>\s*v?(\d+(?:\.\d+)+)\s*</i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Wormhole.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Saved Application State/er.Wormhole.savedState"

  caveats do
    requires_rosetta
  end
end
