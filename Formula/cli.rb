class Cli < Formula
  desc "CLI tool for Hotdata.dev"
  homepage "https://www.hotdata.dev"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.9/hotdata-cli-aarch64-apple-darwin.tar.xz"
      sha256 "ec6c0dc8bb01b43df8b4af41eaccfaf73d07d8e0f4e2ad2304b48e7279bb9719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.9/hotdata-cli-x86_64-apple-darwin.tar.xz"
      sha256 "abb8bba1dac49c8cba5595d0efda6265034eb1a88d72f716864978649ea43760"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.9/hotdata-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b1addaf7ec86ef78dfb07399af84378b21774b01a830c6a7b8ab540117c93809"
    end
    if Hardware::CPU.intel?
      url "https://github.com/hotdata-dev/hotdata-cli/releases/download/v0.1.9/hotdata-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "28c8f550f6a5bc50e029fc379ce91e706d1b3a5143fb19152137e73ca7228cee"
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
