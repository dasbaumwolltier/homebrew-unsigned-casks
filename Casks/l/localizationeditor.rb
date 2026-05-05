cask "localizationeditor" do
  version "2.9.2"
  sha256 "6415313128c1dbbcc0432e7108c2eba87e558ad0b5f6a4a6c80243ceb97220ea"

  url "https://github.com/igorkulman/iOSLocalizationEditor/releases/download/v#{version}/LocalizationEditor.app.zip"
  name "LocalizationEditor"
  desc "iOS app localization manager"
  homepage "https://github.com/igorkulman/iOSLocalizationEditor/"

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "LocalizationEditor.app"

  postflight do |c|
    c.cask.artifacts.grep(Cask::Artifact::App).each do |artifact|
      system_command "/usr/bin/xattr",
                     args:         ["-d", "-r", "com.apple.quarantine", artifact.target],
                     must_succeed: false,
                     print_stderr: false
    end
  end

  # No zap stanza required
end
