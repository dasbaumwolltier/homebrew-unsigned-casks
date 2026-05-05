cask "textbar" do
  version "3.5.6"
  sha256 "61fba4cdab18070c1ba21176072556df42a9c92fc280a51363028d86731a298e"

  url "https://raw.githubusercontent.com/richie5um/richie5um.github.io/master/apps/textbar/TextBar.app-#{version}.zip",
      verified: "raw.githubusercontent.com/richie5um/richie5um.github.io/master/apps/textbar/"
  name "TextBar"
  desc "Add any text to menu bar"
  homepage "http://richsomerfield.com/apps/textbar/"

  livecheck do
    url "https://raw.githubusercontent.com/richie5um/richie5um.github.io/master/apps/textbar/sparkle_textbar.xml"
    strategy :sparkle
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  auto_updates true

  app "TextBar.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/TextBar",
    "~/Library/Caches/com.RichSomerfield.TextBar",
    "~/Library/Preferences/com.RichSomerfield.TextBar.plist",
  ]

  caveats do
    requires_rosetta
  end
end
