cask "wannianli" do
  version "2019-12-06"
  sha256 "702298f34ca2576a02388a4103fc0e09a4aae753df21ca2e012f6f87497db6e9"

  url "https://github.com/zfdang/chinese-lunar-calendar-for-mac/releases/download/#{version}/WanNianLi.app-v#{version.no_hyphens}.zip"
  name "WanNianLi"
  desc "Chinese lunar calendar on the menu bar"
  homepage "https://github.com/zfdang/chinese-lunar-calendar-for-mac/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "WanNianLi.app"

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

  zap trash: "~/Library/Application Support/com.zfdang.calendar"

  caveats do
    requires_rosetta
  end
end
