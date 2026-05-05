cask "electrocrud" do
  version "3.0.19"
  sha256 "d605885ae136077e001ae48c008147008501fd305bdf3de296a4553eb7195e4a"

  url "https://github.com/garrylachman/ElectroCRUD/releases/download/v#{version}/ElectroCRUD-v#{version}-mac-x64.dmg"
  name "ElectroCRUD"
  desc "Database CRUD application"
  homepage "https://github.com/garrylachman/ElectroCRUD"

  livecheck do
    url :url
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "electrocrud.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/ElectroCRUD",
    "~/Library/Preferences/com.garrylachman.electrocrud.plist",
    "~/Library/Saved Application State/com.garrylachman.electrocrud.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
