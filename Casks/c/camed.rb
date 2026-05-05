cask "camed" do
  version "3.2.2"
  sha256 "407e101a3a47566395606b03114388f94f48b488d3fa27041aecb937eb43bd12"

  url "https://downloads.sourceforge.net/camprocessor/CAMEd-#{version}-macosx-cocoa-x86_64.tar.gz"
  name "CAM Editor"
  desc "XML editor"
  homepage "https://sourceforge.net/projects/camprocessor/"

  livecheck do
    url "https://sourceforge.net/projects/camprocessor/rss?path=/CAM%20Editor/Releases"
    regex(%r{url=.*?/CAM%20Editor/Releases/v?(\d+(?:\.\d+)+)/}i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "CAMEd-#{version}/CAMed.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  caveats do
    requires_rosetta
  end
end
