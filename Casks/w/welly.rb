cask "welly" do
  version "3.2.0"
  sha256 "504219867e8ceb625d51fc25c7d3e7488db1eca4877a8734aca5bb9494d5f695"

  url "https://github.com/clyang/welly/releases/download/#{version}/Welly.v.#{version}.zip"
  name "Welly"
  desc "BBS client"
  homepage "https://github.com/clyang/welly"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "Welly.app"

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
    "~/Library/Application Support/Welly",
    "~/Library/Caches/org.net9.Welly",
    "~/Library/Caches/Welly",
    "~/Library/Cookies/org.net9.Welly.binarycookies",
    "~/Library/Preferences/org.net9.Welly.plist",
  ]
end
