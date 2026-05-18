cask "openshift-client" do
  arch arm: "-arm64"

  version "4.21.15"
  sha256 arm:   "af61e6d55a573518084dcc1f16628177a3cc68e7ca9237ab11571a1939732fcc",
         intel: "b8168e0a4ff1b2b3084f8e05062db7de122b2de21aaa2c5572e9398650d8d9a9"

  url "https://mirror.openshift.com/pub/openshift-v#{version.major}/clients/ocp/#{version}/openshift-client-mac#{arch}.tar.gz"
  name "Openshift Client"
  desc "Red Hat OpenShift Container Platform command-line client"
  homepage "https://www.openshift.com/"

  livecheck do
    url "https://mirror.openshift.com/pub/openshift-v#{version.major}/clients/ocp/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  # disable! date: "2026-09-01", because: :fails_gatekeeper_check

  binary "oc"

  zap trash: "~/.kube/config"
end
