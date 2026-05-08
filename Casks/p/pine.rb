cask "pine" do
  version "0.1.0"
  sha256 "046f2603f7e4dcdc7535c6a5652dbfbab5cbe93fa36ca161f8a8029b53770b76"

  url "https://github.com/lukakerr/pine/releases/download/#{version}/Pine-#{version}.zip"
  name "Pine"
  desc "Native markdown editor"
  homepage "https://github.com/lukakerr/pine"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Pine.app"

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
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/io.github.lukakerr.pine.sfl*",
    "~/Library/Application Support/Pine",
    "~/Library/Caches/io.github.lukakerr.Pine",
    "~/Library/Preferences/io.github.lukakerr.Pine.plist",
    "~/Library/Saved Application State/io.github.lukakerr.Pine.savedState",
    "~/Library/WebKit/io.github.lukakerr.Pine",
  ]

  caveats do
    requires_rosetta
  end
end
