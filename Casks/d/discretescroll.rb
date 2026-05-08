cask "discretescroll" do
  version "1.2.1"
  sha256 "f2cc275e4537811bf35b2cec2128c086eefbe613c3b79b08819f4f966f1f7a60"

  url "https://github.com/emreyolcu/discrete-scroll/releases/download/v#{version}/DiscreteScroll.zip"
  name "DiscreteScroll"
  desc "Utility to fix a common scroll wheel problem"
  homepage "https://github.com/emreyolcu/discrete-scroll"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "DiscreteScroll.app"

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

  zap trash: "~/Library/Preferences/com.emreyolcu.DiscreteScroll.plist"
end
