cask "servo" do
  arch arm: "aarch64", intel: "x86_64"

  version "2026-02-21"
  sha256 arm:   "a2383ec0ef36ac77ab2fbe1657ac0ee6321af1e69153438a7952a0678961fde9",
         intel: "3b165de82ca411bc5a614bf47528fd83b569dc9ce30fdb6aa3f65235a41604f0"

  url "https://github.com/servo/servo-nightly-builds/releases/download/#{version}/servo-#{arch}-apple-darwin.dmg",
      verified: "github.com/servo/servo-nightly-builds/"
  name "Servo"
  desc "Parallel browser engine"
  homepage "https://servo.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_latest
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :ventura"

  app "Servo.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Application Support/Servo"
end
