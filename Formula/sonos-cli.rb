class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.0/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "651583b7ad35af2dae041ea097fc12e1e3ee63dd52b4f759c17f2e95aaa6fa2d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.0/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "55f62928bd8228123e6d87e537d8465f132688cde6fe87f82a6ea1ea5439af2f"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tatimblin/sonos-cli/releases/download/v0.11.0/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "eb77288ec124446fad538cd670a32f22e5ca2429928c4dc934364a440507c153"
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
