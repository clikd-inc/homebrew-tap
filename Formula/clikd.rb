class Clikd < Formula
  desc "Local development environment management for Clikd"
  homepage "https://github.com/clikd-inc/cli"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.5.0/clikd-aarch64-apple-darwin.tar.xz"
      sha256 "ae68ecfbeae2f8d1cfe66743a33a19a721ccada6e7d9d6dc0f2069f8799dee1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.5.0/clikd-x86_64-apple-darwin.tar.xz"
      sha256 "e639391a963a9b2aad8aca9b95b1490eed1caba770a2002dfcef86e97be355cf"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/clikd-inc/cli/releases/download/v0.5.0/clikd-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6a4f00c2d7b625452c756f1f24a79d21efc9521acf77477bfece3dbefa690ed0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/clikd-inc/cli/releases/download/v0.5.0/clikd-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dcad8fd56417497241eee39f065cb01331bd8125bb1b06aee486dfe725e08eab"
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
