cask "sunvox" do
  version "2.1.4d"
  sha256 "acd94ae4acd6ab60bee1f5ba117082cd2ea51f7e87871f1776d11cfd24a59880"

  url "https://www.warmplace.ru/soft/sunvox/sunvox-#{version}.zip"
  name "SunVox"
  desc "Modular synthesiser"
  homepage "https://www.warmplace.ru/soft/sunvox/"

  livecheck do
    url :homepage
    regex(/href=.*?sunvox[._-]v?(\d+(?:\.\d+)+[a-z]?)\.zip/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "sunvox/sunvox/macos/SunVox.app"

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
    "/Applications/sunvox_log.txt",
    "~/Library/Application Support/SunVox",
    "~/Library/Preferences/nightradio.SunVox.plist",
    "~/Library/Saved Application State/nightradio.SunVox.savedState",
  ]
end
