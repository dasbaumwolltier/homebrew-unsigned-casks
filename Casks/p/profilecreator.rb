cask "profilecreator" do
  version "0.3.7"
  sha256 "8579e70603a932faa8498181056e09469fa55b3fc2d0397fba165ac21f3a84ba"

  url "https://github.com/ProfileCreator/ProfileCreator/releases/download/#{version}/ProfileCreator-#{version}.dmg"
  name "ProfileCreator"
  desc "Create standard or customised configuration profiles"
  homepage "https://github.com/ProfileCreator/ProfileCreator"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "ProfileCreator.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/ProfileCreator",
    "~/Library/Application Support/ProfilePayloads",
    "~/Library/Preferences/com.github.ProfileCreator.plist",
  ]
end
