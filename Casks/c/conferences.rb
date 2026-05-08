cask "conferences" do
  version "0.0.1-alpha22"
  sha256 "61cd7c47ecc718613c9e1ba803ae36e26c37c98bb6a46b5ced2898942c9771a5"

  url "https://github.com/zagahr/Conferences.digital/releases/download/#{version}/Conferences_v#{version}.zip"
  name "Conferences.digital"
  desc "App to watch conference videos"
  homepage "https://github.com/zagahr/Conferences.digital"

  livecheck do
    url "https://zagahr.github.io/Conferences.digital/appcast.xml"
    regex(/_v(\d+(?:\.\d+)*-.*?)\.zip/i)
    strategy :sparkle do |item, regex|
      item.url[regex, 1]
    end
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Conferences.app"

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
    "~/Library/Application Support/digital.conferences.macos",
    "~/Library/Caches/digital.conferences.macos",
    "~/Library/HTTPStorages/digital.conferences.macos",
    "~/Library/Preferences/digital.conferences.macos.plist",
    "~/Library/Saved Application State/digital.conferences.macos.savedState",
    "~/Library/WebKit/digital.conferences.macos",
  ]

  caveats do
    requires_rosetta
  end
end
