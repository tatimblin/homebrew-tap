class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.3.0/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "c86fc750c007809244905fb9b9a5790cdaee6dfc6518825e7ada669df567a847"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.3.0/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f828d6e14d5b2af6873d18c02dab2aaf753fb63c8182506e283a933bc2203d61"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tatimblin/sonos-cli/releases/download/v0.3.0/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "32abbcff1093c4309da50e19911e5c41a12548cecb893cbc924c7e4b098202e5"
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
