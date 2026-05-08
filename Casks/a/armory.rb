cask "armory" do
  version "0.96.5"
  sha256 "53d0286e54bad62309f3a79a33118f2d1f369be36f9a08b07e61d04aa39f6516"

  url "https://github.com/goatpig/BitcoinArmory/releases/download/v#{version}/armory_#{version}_osx.tar.gz",
      verified: "github.com/"
  name "Armory"
  desc "Python-Based Bitcoin Software"
  homepage "https://btcarmory.com/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Armory.app"

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
