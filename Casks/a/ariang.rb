cask "ariang" do
  arch arm: "arm64", intel: "x64"

  version "1.3.14"
  sha256 arm:   "bb6d460a6cbeb3a494f98d86406b6940ca9cf9ac4680c0c761ffa6eb88b67c2c",
         intel: "04b77d4a908f8d711a2f4826770ca988fcd23421aac36a8e46a184c6cf024022"

  url "https://github.com/mayswind/AriaNg-Native/releases/download/#{version}/AriaNg_Native-#{version}-macOS-#{arch}.dmg"
  name "AriaNg Native"
  desc "Better aria2 desktop frontend than AriaNg"
  homepage "https://github.com/mayswind/AriaNg-Native"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "AriaNg Native.app"

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
    "~/Library/Preferences/net.mayswind.ariang.plist",
    "~/Library/Saved Application State/net.mayswind.ariang.savedState",
  ]
end
