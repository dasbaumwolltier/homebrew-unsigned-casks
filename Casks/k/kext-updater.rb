cask "kext-updater" do
  version "5.0.5"
  sha256 :no_check

  url "https://update.kextupdater.de/kextupdater/kextupdaterng.zip"
  name "Kext Updater"
  desc "Automatic updater for kernel extensions required by Hackintoshes"
  homepage "https://kextupdater.de/"

  livecheck do
    url "https://update.kextupdater.de/kextupdater/appcastng.xml"
    strategy :sparkle, &:short_version
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Kext Updater.app"

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

  zap trash: [
    "~/Library/Caches/kextupdater.slsoft.de",
    "~/Library/Preferences/kextupdater.slsoft.de.plist",
    "~/Library/Preferences/kextupdaterhelper.slsoft.de.plist",
    "~/Library/Saved Application State/kextupdater.slsoft.de.savedState",
  ]
end
