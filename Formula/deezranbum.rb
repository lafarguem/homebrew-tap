class Deezranbum < Formula
  desc "Fetches a random deezer album, without repeats between sessions"
  homepage "https://github.com/lafarguem/deezranbum"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.1.3/deezranbum-aarch64-apple-darwin.tar.xz"
      sha256 "b2ee1714a074ff726c920f5b29fd26a22897c464996d4192d6de478a2bc44d08"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.1.3/deezranbum-x86_64-apple-darwin.tar.xz"
      sha256 "a48213d1c801f6eada6dc08b942fd39091b161cd90fee1a1f29eb37760a42b05"
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
