cask "xcodeclangformat" do
  version "1.2.1"
  sha256 "efc9e926db308977d9ad1ce39925b5c3270eb05aec97a4ae988250d31619d97c"

  url "https://github.com/mapbox/XcodeClangFormat/releases/download/v#{version}/XcodeClangFormat.zip"
  name "XcodeClangFormat"
  desc "Format code in Xcode with clang-format"
  homepage "https://github.com/mapbox/XcodeClangFormat"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "XcodeClangFormat.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: [
    "~/Library/Application Scripts/com.mapbox.XcodeClangFormat",
    "~/Library/Application Scripts/com.mapbox.XcodeClangFormat.clang-format",
    "~/Library/Containers/com.mapbox.XcodeClangFormat",
    "~/Library/Containers/com.mapbox.XcodeClangFormat.clang-format",
    "~/Library/Group Containers/XcodeClangFormat",
  ]

  caveats do
    requires_rosetta
  end
end
