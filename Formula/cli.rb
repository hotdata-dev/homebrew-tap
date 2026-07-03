class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.11.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.11.1/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "2781f408d79e61ebe081318e9ebbbd8f54bc32633ce7705fb79749f36323612b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.11.1/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "26ea7d4f6be6a15e9e348830e599be1e238245dd2ab74d492854b26302d60ce0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.11.1/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "18924967c1c683b58f75312139b1ad3121c98ef767e24242a91d3848f585babd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.11.1/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "334fdc6ddc7aa6b72aa25b737e803f5b0878d5d4113455b23895ad2be1fc5b90"
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
