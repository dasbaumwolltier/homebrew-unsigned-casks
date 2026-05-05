cask "arkiwi" do
  version "4.1.5"
  sha256 "d73ec198377a785effe76d4c444875de27bbe00becb0311f70036155220ee590"

  url "https://www.mariogt.com/appsChest/ArKiwi#{version.dots_to_hyphens}.zip"
  name "ArKiwi"
  desc "File archiver"
  homepage "https://www.mariogt.com/arkiwi.html"

  livecheck do
    url "https://www.mariogt.com/appsChest/arkiwiAppCast.xml"
    strategy :sparkle, &:short_version
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "ArKiwi.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Containers/com.mariogt.arkiwi/Data/Library/Application Support/ArKiwi",
    "~/Library/Containers/com.mariogt.arkiwi/Data/Library/Preferences/com.mariogt.arkiwi.plist",
  ]
end
