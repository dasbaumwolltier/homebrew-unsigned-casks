cask "dyn-updater" do
  version "5.5.0"
  sha256 "70cb2600907b05adf5a912baaee7512b6d70331405c551414889a49608a1fab9"

  url "http://cdn.dyn.com/dynupdater/DynUpdater-#{version}.zip"
  name "Dyn Updater"
  homepage "https://dyn.com/updater/"

  livecheck do
    url "http://cdn.dyn.com/dynupdater/appcast.xml"
    strategy :sparkle
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Dyn Updater.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  caveats do
    requires_rosetta
  end
end
