cask "disk-inventory-x" do
  version "1.3"
  sha256 "78af3506435adaa53d8cc2ce601cac2e13b56e708358eb3bde2c3aa322bad8e5"

  url "https://www.derlien.com/diskinventoryx/downloads/Disk%20Inventory%20X%20#{version}.dmg",
      user_agent: :fake
  name "Disk Inventory X"
  desc "Disk usage utility"
  homepage "https://www.derlien.com/"

  livecheck do
    url "https://www.derlien.com/download.php?file=DiskInventoryX"
    strategy :header_match
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Disk Inventory X.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Preferences/com.derlien.DiskInventoryX.plist"

  caveats do
    requires_rosetta
  end
end
