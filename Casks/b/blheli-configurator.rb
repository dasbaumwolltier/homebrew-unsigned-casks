cask "blheli-configurator" do
  version "1.2.0"
  sha256 "6a2631409483b3c706c23f9da8e00f9420f86b874d6697d4b32f9d4619a0768e"

  url "https://github.com/blheli-configurator/blheli-configurator/releases/download/#{version}/BLHeli-Configurator_macOS_#{version}.dmg"
  name "BLHeli Configurator"
  homepage "https://github.com/blheli-configurator/blheli-configurator"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "BLHeli Configurator.app"

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

  caveats do
    requires_rosetta
  end
end
