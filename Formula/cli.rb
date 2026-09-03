class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.30.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.30.0/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b684f2afa25b59c057ef49d64e03468ed4fc05646c013e99e32e2bdcd5d58f30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.30.0/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "552b3bf5a7080c6068de79fdd7704cbee25642a96a2aa8434ec3b1b84de80864"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.30.0/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5e274ef960505504a166dc93c5e4c61e0a42c0e00d549943a3c1e80a120eb848"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.30.0/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "efe34e95c170234921832d3e2161c3fc2b5de966463f4a86f5b610e88b55c99f"
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
    generate_completions_from_executable(bin/"hotdata", "completions")
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
