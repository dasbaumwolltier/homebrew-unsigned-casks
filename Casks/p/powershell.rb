cask "powershell" do
  arch arm: "arm64", intel: "x64"

  version "7.6.3"
  sha256 arm:   "84ec89be312a761d49bf4ec6e676355a715a01cb36b4e53cd16084e98bdac492",
         intel: "843c719ce1c36d7c510878db2d20a3dd51108dd46679c34feb891ac2adfbf4d3"

  url "https://github.com/PowerShell/PowerShell/releases/download/v#{version}/powershell-#{version}-osx-#{arch}.pkg"
  name "PowerShell"
  desc "Command-line shell and scripting language"
  homepage "https://github.com/PowerShell/PowerShell"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  pkg "powershell-#{version}-osx-#{arch}.pkg"

  uninstall pkgutil: "com.microsoft.powershell"

  zap trash: [
    "~/.cache/powershell",
    "~/.config/powershell",
    "~/.local/share/powershell",
  ]

  caveats <<~EOS
    To use Homebrew in PowerShell, run the following in a PowerShell session:
      New-Item -Path (Split-Path -Parent -Path $PROFILE.CurrentUserAllHosts) -ItemType Directory -Force
      Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(#{HOMEBREW_PREFIX}/bin/brew shellenv) | Invoke-Expression'
  EOS
end
