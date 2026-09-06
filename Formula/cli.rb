class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.32.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.32.0/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1650a674f7ea19ae455a045067328d8a25988b883ef0afe44e1fb66a9cafd9d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.32.0/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "73d84bc9f59f5c86da2867e61305c592ad1e0958711e4210db761d76dcbdeac7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.32.0/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cd34bd5a538b4a6937f7e6c7d16cd950ade08e1d180482705cbcc5ddf0546b3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.32.0/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "78fc504b88af5052f1ad9e7602fa24e6cdb1d6c778f33e3ad2ead8e40a4532c6"
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
