class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.1/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "75014a4b32af9cc97fabc8d806acc3a4784c750ce48e56e50422eab5f7e662de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.1/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "6bc3e3061ecb321e799f3c100c2d5f0f5145571fcae4d0527e9b6022270e7c3d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.1/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "2a5363454f70f077df9e3df04fbff1cc99cbfec949ca204e4b9876d8fe9cda2d"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sonos"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sonos"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sonos"
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
