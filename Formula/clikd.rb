class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.3/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "454b39fef7ff334c53f50beb53d8221854c1ea77f11241692994ace9297c401d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.3/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "425e7929c5f4e22e3d0f9fb53204fe13adc80ab40e0db65e4f8566a82204ee4e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.3/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c3bd20e05db8fb617f5eb84368334871ca4cf38401c34f6a8f127fdd7d7c2af7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.3/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "721b516d3247e5172a4ada69a8df16c875fb62e3cdb34c841f7fad543c85ff25"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "clikd" if OS.mac? && Hardware::CPU.arm?
    bin.install "clikd" if OS.mac? && Hardware::CPU.intel?
    bin.install "clikd" if OS.linux? && Hardware::CPU.arm?
    bin.install "clikd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
