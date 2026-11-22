class SonosCli < Formula
  desc "CLI and TUI for controlling Sonos speakers"
  homepage "https://github.com/tatimblin/sonos-cli"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.9.1/sonos-cli-aarch64-apple-darwin.tar.xz"
      sha256 "08371d525e5e1ba5d7377811a6f707089a9abdf9791d53f66f137fc026f8018a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/sonos-cli/releases/download/v0.9.1/sonos-cli-x86_64-apple-darwin.tar.xz"
      sha256 "09b8b3192ba82681d68bf86f8dd5d3cae35e1e812cf2bcbb45a8c43676722bf8"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tatimblin/sonos-cli/releases/download/v0.9.1/sonos-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "62c0e87bf9588222bde5998ef27bb8900f6c823adf3417c7b55f2dd78d8551bd"
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
