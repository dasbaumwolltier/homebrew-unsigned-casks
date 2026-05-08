cask "knuff" do
  version "1.3"
  sha256 "06c6bb6d2254211f4369a9903aefb61eb894c706b08635091f457d1730b79c69"

  url "https://github.com/KnuffApp/Knuff/releases/download/v#{version}/Knuff.app.zip"
  name "Knuff"
  desc "Debug application for Apple Push Notification Service (APNs)"
  homepage "https://github.com/KnuffApp/Knuff"

  livecheck do
    url "https://knuffapp.github.io/sparkle.xml"
    strategy :sparkle, &:short_version
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "Knuff.app"

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
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.madebybowtie.knuff-osx.sfl*",
    "~/Library/Application Support/com.makebybowtie.Knuff-OSX",
    "~/Library/Caches/com.crashlytics.data/com.madebybowtie.Knuff-OSX",
    "~/Library/HTTPStorages/com.madebybowtie.Knuff-OSX",
    "~/Library/Preferences/com.madebybowtie.Knuff-OSX.plist",
  ]

  caveats do
    requires_rosetta
  end
end
