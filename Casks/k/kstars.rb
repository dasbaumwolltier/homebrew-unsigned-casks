cask "kstars" do
  version "3.8.2"
  sha256 :no_check # required as upstream package is updated in-place

  url "https://www.indilib.org/jdownloads/kstars/kstars-#{version}.dmg",
      user_agent: :browser,
      verified:   "indilib.org/jdownloads/kstars/"
  name "KStars"
  desc "Astronomy software"
  homepage "https://kstars.kde.org/"

  livecheck do
    url :homepage
    regex(/href=.*?kstars[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :ventura"

  app "kstars.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/kstars",
    "~/Library/Caches/kstars",
    "~/Library/Preferences/kstars",
    "~/Library/Preferences/kstarsrc",
  ]

  caveats do
    requires_rosetta
  end
end
