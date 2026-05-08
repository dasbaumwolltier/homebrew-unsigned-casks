cask "vidcutter" do
  version "6.0.5.1"
  sha256 "8d1556887f0b203ebcb7b6e13a33389afad173a2c73dbc906b69ece034218f02"

  url "https://github.com/ozmartian/vidcutter/releases/download/#{version}/VidCutter-#{version}-macOS.dmg"
  name "VidCutter"
  desc "Media cutter and joiner"
  homepage "https://github.com/ozmartian/vidcutter"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "VidCutter.app"

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

  caveats do
    requires_rosetta
  end
end
