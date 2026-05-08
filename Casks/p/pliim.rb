cask "pliim" do
  version "1.7.0"
  sha256 "cd44a3e8d0d58b431df288c3ce13a8032f76b270077ac488cb9db5d74e7d17a5"

  url "https://github.com/zehfernandes/pliim/releases/download/v#{version}/Pliim.app.zip",
      verified: "github.com/zehfernandes/pliim/"
  name "Pliim"
  desc "One click and be ready to go up on stage and shine!"
  homepage "https://zehfernandes.github.io/pliim/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Pliim.app"

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
    "~/Library/Application Support/Pliim",
    "~/Library/Logs/Pliim",
    "~/Library/Preferences/com.electron.pliim.plist",
    "~/Library/Saved Application State/com.electron.pliim.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
