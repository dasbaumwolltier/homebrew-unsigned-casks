cask "desmume" do
  version "0.9.13"
  sha256 "d42e4bbf8f96b6bfdb3c8be6cf469b606a3b105352460636b1051b8dd0365ebc"

  url "https://github.com/TASEmulators/desmume/releases/download/release_#{version.tr(".", "_")}/desmume-#{version}-macOS.dmg",
      verified: "github.com/TASEmulators/desmume/"
  name "DeSmuME"
  desc "Nintendo DS emulator"
  homepage "https://desmume.org/"

  livecheck do
    url :url
    regex(/^(?:release[._-])?(\d+(?:[._-]\d+)+[a-z]?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "DeSmuME.app"

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
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/org.desmume.desmume.sfl*",
    "~/Library/Application Support/DeSmuME",
    "~/Library/Preferences/org.desmume.DeSmuME.plist",
    "~/Library/Saved Application State/org.desmume.DeSmuME.savedState",
  ]
end
