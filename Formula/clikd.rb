class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/clikd"
  version "0.1.0"
  license "MIT"

  if Hardware::CPU.arm?
    url "https://github.com/clikd-inc/cli/releases/download/v0.1.0/clikd_0.1.0_darwin_arm64.zip"
    sha256 ""
  else
    url "https://github.com/clikd-inc/cli/releases/download/v0.1.0/clikd_0.1.0_darwin_amd64.zip"
    sha256 ""
  end

  def install
    bin.install "clikd" => "clikd"
    
    # Shell completions
    output = Utils.safe_popen_read("#{bin}/clikd", "completion", "bash")
    (bash_completion/"clikd").write output
    
    output = Utils.safe_popen_read("#{bin}/clikd", "completion", "zsh")
    (zsh_completion/"_clikd").write output
    
    output = Utils.safe_popen_read("#{bin}/clikd", "completion", "fish")
    (fish_completion/"clikd.fish").write output
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/clikd --version")
  end
end
