cask "qview" do
  version "7.1"
  sha256 "fa34d0e54601b8557f4e879527b9bb1e728ace5c7c1c69cf126700ca4d0b5817"

  url "https://github.com/jurplel/qView/releases/download/#{version}/qView-#{version}.dmg"
  name "qView"
  desc "Image viewer"
  homepage "https://github.com/jurplel/qView/"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :monterey"

  app "qView.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.interversehq.qview.sfl*",
    "~/Library/Preferences/com.interversehq.qView.plist",
    "~/Library/Preferences/com.qview.qView.plist",
    "~/Library/Saved Application State/com.interversehq.qView.savedState",
  ]
end
