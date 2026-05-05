cask "exifcleaner" do
  version "3.6.0"
  sha256 "459b296b000a7cd614713772e9b4ecf1604d3bb10926ab2346e8ea88e44df323"

  url "https://github.com/szTheory/exifcleaner/releases/download/v#{version}/ExifCleaner-#{version}.dmg",
      verified: "github.com/szTheory/exifcleaner/"
  name "ExifCleaner"
  desc "Metadata cleaner"
  homepage "https://exifcleaner.com/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "ExifCleaner.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Support/ExifCleaner",
    "~/Library/Saved Application State/com.exifcleaner.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
