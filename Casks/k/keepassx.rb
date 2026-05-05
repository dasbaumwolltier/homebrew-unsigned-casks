cask "keepassx" do
  version "2.0.3"
  sha256 "44271fef18fd07a29241e5324be407fa8edce77fb0b55c5646cd238092cdf823"

  url "https://www.keepassx.org/releases/#{version}/KeePassX-#{version}.dmg"
  name "KeePassX"
  desc "Personal data manager focusing on security"
  homepage "https://www.keepassx.org/"

  livecheck do
    url "https://www.keepassx.org/downloads/"
    regex(/href=.*?KeePassX[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "KeePassX.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  uninstall_preflight do
    set_ownership "#{appdir}/KeePassX.app"
  end

  zap trash: "~/.keepassx"

  caveats do
    requires_rosetta
  end
end
