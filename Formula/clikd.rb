class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.6/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "40e7b497b81c6f7e37f16e7ea749f4b93daf7a0277b3b6c9370e506e6f24e914"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.6/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "bff106b35bac09b4d2d65f8f3724bfbf475a12b93db4042cc39ed7777ef3e29a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.6/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d634575c412e2e4dac85ea0c46a267757896a44c02d82311295fd7a495c78e79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.6/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a085e6658e668f47dcff97b8ad9b107eb6f13ee35425bfdb50baf4e05e3585c7"
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
