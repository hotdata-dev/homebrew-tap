class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.17.1/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "662c5aa48fd61e0a9c96671f7c243f3053a55137b432b9574ed71aab9917b3a3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.17.1/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4fa0fb88b6040468cdb5499c3f954f0ab8823c1c5d8963326e6b3b0537b0ee46"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.17.1/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "183162cb3b55406f8a1c6def9a14f2ffa9819acf20c88e3d7fd8c0219b91d540"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.17.1/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0264c2eb746047358d9888e2dc4c41d29833286adffd358dcf7df682be11f4ed"
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
