cask "mark-text" do
  arch arm: "arm64", intel: "x64"

  version "0.17.1"
  sha256 arm:   "c7fb2f9917b0626999d4fef9a1827ccc515afb1c32f7453977af5c1cbcd9de4f",
         intel: "83320faad3b217079f6638b1f4169ffc37465f255a93e262d1646f2a5f53f263"

  url "https://github.com/marktext/marktext/releases/download/v#{version}/marktext-#{arch}.dmg"
  name "MarkText"
  desc "Markdown editor"
  homepage "https://github.com/marktext/marktext"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "MarkText.app"

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
    "~/Library/Application Support/marktext",
    "~/Library/Logs/marktext",
    "~/Library/Preferences/com.github.marktext.marktext.plist",
    "~/Library/Saved Application State/com.github.marktext.marktext.savedState",
  ]
end
