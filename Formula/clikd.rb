class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.1/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "3833426a16058c13836020d393e096b9fc16066258ad4b8d6a25b6dc8ede0164"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.1/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "23b1b143578dc4fdc9dd4b7b59d67454060fd1f13781251bd024b92dce687f61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.1/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b0a7c3441de1029c0ff1808e739feb8500a679d9caf1ff2fd554bb07ae88ca60"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.2.1/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab7404e0e52312f20c9478574f717601a9fbf3bd66c5b57d26ff0ec067bb6ef5"
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
