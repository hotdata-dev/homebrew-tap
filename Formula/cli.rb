class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.42.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.42.0/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b0daca21a3488852db89bcf7596192ea85d4a0821117c204cba65c081891f52b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.42.0/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "5e04b4d6d01c3f4a80e6b60cdf65f8ee2c15c12c91988b4b5e7a89b6ac80fe31"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.42.0/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5e819b3ff36ba08970075322e1dac341852e2d8febc084fab8fc64384272999"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.42.0/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "771c598ba6f2d0d6d06031a3e6e54a19ef272ad3f9c7eb05eecc173b4ffadbc0"
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
