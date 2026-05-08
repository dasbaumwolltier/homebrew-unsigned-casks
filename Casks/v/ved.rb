cask "ved" do
  version "1.12.2"
  sha256 "c5d413a1cb6ba45900e3e79f3789d9a0eb78bf18b90ea8d2b138bde35c98a00b"

  url "https://tolp.nl/ved/files/download/mac/ved_#{version}_mac.dmg"
  name "ved"
  desc "External level editor for VVVVVV"
  homepage "https://tolp.nl/ved/"

  livecheck do
    url "https://tolp.nl/ved/files/download/mac/"
    regex(/href=.*?ved[ ._-]v?(\d+(?:\.\d+)+)[ ._-]mac\.dmg/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Ved.app"

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
    "~/Library/Application Support/ved",
    "~/Library/Caches/nl.tolp.ved",
    "~/Library/Saved Application State/nl.tolp.ved.savedState",
  ]
end
