class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.7.1/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "247d7bb3dc37d1730f1eb3c341562b9a93ac252287b029571235fe25649f9c68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.7.1/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "0f0b153d335093cf5062ef5c470127e808c2e3f69bc8a686e29494478e8b354e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.7.1/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "af53df5e184b0ca385d1a7272ebf9c43799dec2f6c8d037865378de2aa685f1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.7.1/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "250c54172f8c16144b031a1897e05bdf595020cc313f0d5385b39f01a6c5607c"
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
