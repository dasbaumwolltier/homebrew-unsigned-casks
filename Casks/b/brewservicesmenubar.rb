cask "brewservicesmenubar" do
  version "4.1"
  sha256 "9736f68d97ccab2028fe1f9167fe60e229562ae10f56f5506585ce4747a3d055"

  url "https://github.com/andrewn/brew-services-menubar/releases/download/v#{version}/BrewServicesMenubar-v#{version}.zip"
  name "Brew Services Menubar"
  desc "Menu item for starting and stopping homebrew services"
  homepage "https://github.com/andrewn/brew-services-menubar"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "BrewServicesMenubar.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  uninstall quit: "andrewnicolaou.BrewServicesMenubar"

  zap trash: "~/Library/Preferences/andrewnicolaou.BrewServicesMenubar.plist"
end
