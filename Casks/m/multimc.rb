cask "multimc" do
  version "0.7.0"
  sha256 :no_check

  url "https://files.multimc.org/downloads/mmc-stable-osx64-5.15.2.tar.gz"
  name "Multi MC"
  desc "Minecraft launcher"
  homepage "https://multimc.org/"

  livecheck do
    url "https://files.multimc.org/update/osx64-5.15.2/stable/index.json"
    strategy :json do |json|
      json["Versions"]&.map { |version| version["Name"] }
    end
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "MultiMC.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Caches/MultiMC",
    "~/Library/Preferences/org.multimc.MultiMC5.plist",
    "~/Library/Saved Application State/org.multimc.MultiMC5.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
