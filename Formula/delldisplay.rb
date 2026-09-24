class Delldisplay < Formula
  desc "Control Dell monitors over DDC/CI: brightness, inputs, PiP/PBP, USB KVM"
  homepage "https://github.com/tatimblin/delldisplay"
  url "https://github.com/tatimblin/delldisplay/releases/download/v0.1.0/delldisplay-v0.1.0-macos-universal.tar.gz"
  sha256 "e05dbaca52f7ae0fee62411a75740d573e415f334176867c11fd2a9c8e34becd"
  license "MIT"

  depends_on :macos

  def install
    bin.install "delldisplay"
  end

  def caveats
    <<~EOS
      Turn on DDC/CI on the monitor first: OSD Menu > Others > DDC/CI.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delldisplay --version")
  end
end
