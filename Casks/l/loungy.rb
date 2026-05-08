cask "loungy" do
  version "0.1.3"
  sha256 "4d901b7dc6a02c6e51ba2af941ecd038b02308a642e330505a8f8882b07deb19"

  url "https://github.com/MatthiasGrandl/Loungy/releases/download/v#{version}/Loungy_#{version}_universal.dmg"
  name "Loungy"
  desc "Application launcher"
  homepage "https://github.com/MatthiasGrandl/Loungy"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Loungy.app"

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
    "~/.config/loungy",
    "~/Library/Application Support/loungy",
    "~/Library/Caches/loungy",
  ]
end
