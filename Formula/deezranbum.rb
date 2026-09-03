class Deezranbum < Formula
  desc "Fetches a random deezer album, without repeats between sessions"
  homepage "https://github.com/lafarguem/deezranbum"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.2.1/deezranbum-aarch64-apple-darwin.tar.xz"
      sha256 "8d74c9ee1b35a6202f9badd98837320712de26a14a8da8ce8a7c0763492e0427"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.2.1/deezranbum-x86_64-apple-darwin.tar.xz"
      sha256 "bcd1b6860a96f8f1f8e8378684fc53f1ebfce71d918e28a4250329b2422b1bf4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
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
      bin.install "deezranbum"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "deezranbum"
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
