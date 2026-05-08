cask "opencore-configurator" do
  version "2.78.2.0"
  sha256 :no_check

  url "https://mackie100projects.altervista.org/apps/opencoreconf/download-new-build.php?version=last",
      referer: "https://mackie100projects.altervista.org/"
  name "OpenCore Configurator"
  desc "OpenCore EFI bootloader configuration helper"
  homepage "https://mackie100projects.altervista.org/opencore-configurator/"

  livecheck do
    url "https://mackie100projects.altervista.org/apps/opencoreconf/OCC/update-data-builds.xml"
    strategy :sparkle
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "OpenCore Configurator.app"

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
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.altervista.mackie100projects.opencore-configurator.sfl*",
    "~/Library/Application Support/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/Caches/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/HTTPStorages/org.altervista.mackie100projects.OpenCore-Configurator",
    "~/Library/Preferences/org.altervista.mackie100projects.OpenCore-Configurator.plist",
  ]

  caveats do
    requires_rosetta
  end
end
