class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.2.0/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "6a77f5240bda35ede5563367f6c8a3486b83f02858f5e93d1181a254c47af96e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.2.0/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b056ca79749bb208c1a3773afec3213da64f6cbdfbcaf8f506f806b891eef56c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.2.0/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f70d829099c2fc47707b31fd29a7a955e540667df9c143cf8c5bfe6bec11e6cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.2.0/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9450ede5602a007bbee21beced8ff4b6fe9dbd6722dddae4c48bdd71a3b0c3a5"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "hotdata" if OS.mac? && Hardware::CPU.arm?
    bin.install "hotdata" if OS.mac? && Hardware::CPU.intel?
    bin.install "hotdata" if OS.linux? && Hardware::CPU.arm?
    bin.install "hotdata" if OS.linux? && Hardware::CPU.intel?
    generate_completions_from_executable(bin/"hotdata", "completions")

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
