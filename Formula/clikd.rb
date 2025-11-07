class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.4/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "bbceb4864294c35b3cd83efaa95e5b08d0d75ed1e2e3c764c362c8d4a38fe6ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.4/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "bd7628ebc96c5a0896bdb21a88860a1f99cdd372334d39a0a4296ceb1d8329c8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.4/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86e488f9ead68c330f076c0613d7a2ac9e2934fefdb5c55d32ac4c1f5e89c43a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.4/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3155fe1f02d80ad3ce336075fe7f3197ee7e5a5ea5febe4d6a29e4f1b6ebbb9c"
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
