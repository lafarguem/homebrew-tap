class Deezranbum < Formula
  desc "Fetches a random deezer album, without repeats between sessions"
  homepage "https://github.com/lafarguem/deezranbum"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.2.2/deezranbum-aarch64-apple-darwin.tar.xz"
      sha256 "02cae6f2dc21aaee56f84bfdc9355e34d3c21002d04cdaf06da3a0ccae83bee9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lafarguem/deezranbum/releases/download/v0.2.2/deezranbum-x86_64-apple-darwin.tar.xz"
      sha256 "0ca51f1f4e4152af62ce0a2bd5fe311a06148dca1b3490ced926e691e51dc3ec"
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
