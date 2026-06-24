cask "openshift-client" do
  arch arm: "-arm64"

  version "4.22.2"
  sha256 arm:   "16fa68703a4b7f35bc0a90906f9c925015144b549e0d2f6335353cef30484ade",
         intel: "2608b594bb2991ba35c48beafce8cbe634b1ec72812447d85593e9e498e60e14"

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
