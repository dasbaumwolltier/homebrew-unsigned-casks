cask "pronterface" do
  version "2.2.0"
  sha256 "b3fa041bb478b9d66b4a7654d93236b38ad36ec90370891943569c1073886e2b"

  url "https://github.com/kliment/Printrun/releases/download/printrun-#{version}/printrun-#{version}_macos_x64.zip"
  name "Printrun"
  desc "Control your 3D printer from your PC"
  homepage "https://github.com/kliment/Printrun"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "pronterface.app"

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
    "~/Library/Preferences/Pronterface.plist",
    "~/Library/Saved Application State/Pronterface.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
