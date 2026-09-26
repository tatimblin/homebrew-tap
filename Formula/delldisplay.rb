class Delldisplay < Formula
  desc "Command-line control for Dell monitors over DDC/CI."
  homepage "https://github.com/tatimblin/delldisplay"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tatimblin/delldisplay/releases/download/v0.1.2/ddc-cli-aarch64-apple-darwin.tar.xz"
      sha256 "4a41317a30d9f69d676b5834145ce4ca8c180f1ca2d183e8e96a3460268e2d29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tatimblin/delldisplay/releases/download/v0.1.2/ddc-cli-x86_64-apple-darwin.tar.xz"
      sha256 "a2e12b45574b4ba9cbc57f14bdcfa92cb24a7688e028f9b3e2b3899f903a465d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "delldisplay"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "delldisplay"
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
