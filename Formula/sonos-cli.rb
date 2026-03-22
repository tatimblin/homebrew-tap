class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.1/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4fbcc11a3f5f0221804f5b59d4e1c7ded9a67719ec30344c7d83b92349e9b42f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.1/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1b0dde142626f065569101f98f20dd921eae02cbe443d91e40644c0928462d48"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.1/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "908a82d9bd3d5f23d91a0b5226f3606702bc098e0aa9b02437774c9bbcd0844e"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "sonos" if OS.mac? && Hardware::CPU.arm?
    bin.install "sonos" if OS.mac? && Hardware::CPU.intel?
    bin.install "sonos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
