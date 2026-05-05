cask "wombat" do
  version "0.5.0"
  sha256 "a655f77a5e55b1fbea7f4855d8d536c52d701bdb1ac7c466e1e5656a208421bf"

  url "https://github.com/rogchap/wombat/releases/download/v#{version}/Wombat_v#{version}_Darwin_x86_64.dmg"
  name "Wombat"
  desc "Cross platform gRPC client"
  homepage "https://github.com/rogchap/wombat"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Wombat.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Application Support/Wombat"

  caveats do
    requires_rosetta
  end
end
