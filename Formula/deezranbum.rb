class Deezranbum < Formula
  desc "Fetches a random deezer album, without repeats between sessions"
  homepage "https://github.com/lafarguem/deezranbum"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.1.8/deezranbum-aarch64-apple-darwin.tar.xz"
      sha256 "6a9663ca1d62d6c972cfff703104f654f06d6da1c46e04cfc66efea1925760ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.1.8/deezranbum-x86_64-apple-darwin.tar.xz"
      sha256 "27d0ec7e513ce40c854ebb6ec7ca17c080c35fbda009e45d59a1ede186c22aef"
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
    bin.install "deezranbum" if OS.mac? && Hardware::CPU.arm?
    bin.install "deezranbum" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
