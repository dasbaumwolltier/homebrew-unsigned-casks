cask "openshift-client" do
  arch arm: "-arm64"

  version "4.22.0"
  sha256 arm:   "bea11cd54572db185e539ca5a33e7bc9ae5e713479b1554af1279236571823e0",
         intel: "e900525abfd5ff7cad47b4731d35b84fcb01e254c4de4d82ec5f8b1168d7bd75"

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
