cask "ultrastardeluxe" do
  arch arm: "ARM", intel: "x86"

  version "2026.6.0"
  sha256 arm:   "5850c276cd686765d78452bb3ae3d04e2c19e7c16b73f46d46d46921a7ff9c8d",
         intel: "b714979edccbbe8f5623abb0d86ca8c9ce40a99499ba9f4386d25553eb970bb2"

  url "https://github.com/UltraStar-Deluxe/USDX/releases/download/v#{version}/UltraStarDeluxe-mac-#{arch}-#{version}.dmg",
      verified: "github.com/UltraStar-Deluxe/USDX/"
  name "UltraStar Deluxe"
  desc "Karaoke game"
  homepage "https://usdx.eu/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "UltraStarDeluxe.app"

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

  zap trash: "~/Library/Application Support/UltraStarDeluxe1.3"
end
