cask "yippy" do
  version "2.8.1"
  sha256 "89d8c2c628637cc72ff6f8a3ca0d07484479a1becb66cedaa67a12062d148131"

  url "https://github.com/mattDavo/Yippy/releases/download/#{version}/Yippy.zip"
  name "Yippy"
  desc "Open source clipboard manager"
  homepage "https://github.com/mattDavo/Yippy"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Yippy.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  zap trash: "~/Library/Application Support/MatthewDavidson.Yippy"

  caveats do
    requires_rosetta
  end
end
