class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.0/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "413e120ac8e51b449c3e39a2e337e1dba94a63c3c349df7ce2a62ec8b27444fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.0/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "666242d073eb83ee3719f381ec8a39d5a4e8dca073e05139f1cd7b4ddad20c14"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.1.0/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c8b0eb65a4fbe5cd8b30ccca94203bd6af0dce9e571fa102888a76aafe66d5c"
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
