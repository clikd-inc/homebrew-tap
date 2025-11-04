class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.2/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "f08dd761ceec12f9dea899db077151707af4491224c5ec6afb9457bc3a88a9ea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.2/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "92f6ca11a0c2293c962ddbe43e83050d1c1d8c1e5819023cfdeecf69802b7458"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.2/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dad62153b594344a317cb612a20ab8fdcb64167f395fdf0bbfe5bdee97dc62fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.2/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ce1af850f4364781e680cac27eaf2b62c9d4a926c709e06877276fbb6473ee58"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "clikd"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "clikd"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "clikd"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "clikd"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
