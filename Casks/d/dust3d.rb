cask "dust3d" do
  version "1.0.3"
  sha256 "be8fb61b13b17a1cc11771b7f0055cccb5197f3a6d5bf797fabcceb5e3a8df4e"

  url "https://github.com/huxingyi/dust3d/releases/download/#{version}/dust3d-#{version}.dmg",
      verified: "github.com/huxingyi/dust3d/"
  name "Dust3D"
  desc "Open-source 3D modelling software"
  homepage "https://dust3d.org/"

  # TODO: Update this regex to only match stable versions once 1.0.0 stabilizes:
  # regex(/^v?(\d+(?:\.\d+)+)$/i)
  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:-rc\.?\d*)?)$/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "dust3d-#{version}.app"

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

  zap trash: "~/Library/Saved Application State/com.yourcompany.dust3d.savedState"

  caveats do
    requires_rosetta
  end
end
