class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.2.0/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "27881c1cfcd6e889265aa8a93933fd668da36eab4aca6b9795901dda3a602a95"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.2.0/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a922baaa0ff4dcfaa22dda192bd0f8fd4de0a02344da4d2bc97ba1565ceb7efa"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tatimblin/sonos-cli/releases/download/v0.2.0/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f4366aaec7746ecc6e3aa24939eecfea80ea8cbf6112c7b04b3787ec358203ab"
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
