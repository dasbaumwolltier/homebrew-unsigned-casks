cask "amitv87-pip" do
  version "3.01"
  sha256 "3317ddd35ae36b16f06d501c6b870aeb0565548cc07165c0bd1df23ac1af8d83"

  url "https://github.com/amitv87/PiP/releases/download/v#{version}/PiP-#{version}.dmg"
  name "PiP"
  desc "Always on top window preview"
  homepage "https://github.com/amitv87/PiP"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "PiP.app"

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

  zap trash: "~/Library/Saved Application State/com.boggyb.PiP.savedState"
end
