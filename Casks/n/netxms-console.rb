cask "netxms-console" do
  arch arm: "-aarch64"

  version "6.1.1"
  sha256 arm:   "52d1120fde88981a56a9b69a057d6c9d0e4f79b1c023a8b8804f4257ca68f245",
         intel: "6612dc636563fe3d1f6b0a3026a07ee09845da4587a493ce50d664d3f4cb1741"

  url "https://netxms.com/download/releases/#{version.major_minor}/nxmc-#{version}#{arch}.dmg"
  name "NetXMS Management Console"
  desc "Network and infrastructure monitoring and management system"
  homepage "https://netxms.com/"

  livecheck do
    url "https://netxms.com/downloads/"
    regex(/href=.*?nxmc[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  depends_on macos: ">= :big_sur"

  app "NetXMS Console (#{version}).app"

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

  zap trash: "~/.nxmc"
end
