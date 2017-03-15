class MobileShellSshAgent < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://api.github.com/repos/rinne/mosh/tarball/9ebe3ed2aad6a3c5bcf4c4c2a9d2ace097a53d03"
  sha256 "ddfdef9346a31a1eb8bb12f8b140ce2770fd23280444851fd5e05347d3e82de1"
  revision 1

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--enable-agent-forwarding"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
