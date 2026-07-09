class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.14.0/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "410c6d1cdca0e8135e87136c99f6a38399da76af216d7d82aeabaff2f2468535"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.14.0/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bafd8ea050e779ec22b75c8cec49e947d7dc6bdd1510043037dd21887b6a1d48"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.14.0/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "09a06070b00d387b842c68631e5d6610931e76a95d90a8fd4562ed83b781895f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.14.0/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4fb6b1a576c89a0662e17fdb4684c41c43eb257c80494cca43bffd143a9a593a"
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
