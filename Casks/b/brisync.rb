cask "brisync" do
  version "2.0.0"
  sha256 "1843bd9a9a537926029e80f47c46f5c17ecfae6b4086470f4ea0bef00b89596f"

  url "https://github.com/czarny/Brisync/releases/download/v#{version}/Brisync.zip"
  name "Brisync"
  desc "Utility to automatically control the brightness of external displays"
  homepage "https://github.com/czarny/Brisync/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "Brisync.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/.brisync.json"
end
