class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.45.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.45.1/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "84ab3385ec0be9aec78e94168bfe05656927b801a9a1b8660c13f5a5b23fcfed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.45.1/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0671e17090e49f08acad8f1864592cb75d0059ab98ff40b2f9e67145a94916ec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.45.1/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25b7e341aff15dde4f777dac1b63495e07151e3058da0a11da25b87e9c6c90cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.45.1/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "097e508650ce93833c1228a5799c774c5e111e273765c4495e3ca5d5e29f98da"
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
