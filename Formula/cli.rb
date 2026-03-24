class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.5/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1a755585c9ff24f8343b87a005700aeee13d22086b6ddbfa52761339e4fd3649"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.5/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "3d427caf93b8119919fef1f8a70c6b0d633a6fe28727198927aa8818d7ba827b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.5/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec8b011707070b558f0a096f6b211a635156e4eeb11f736c6742643c02038146"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.5/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c1d7441193dd8804e7a63287afdd0992f5032d34d4cdd0d1e43822529db868b5"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
      bin.install "hotdata"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hotdata"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hotdata"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hotdata"
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
