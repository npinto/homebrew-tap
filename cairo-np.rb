require 'formula'

class CairoNp < Formula
  homepage 'http://cairographics.org/'
  url 'http://www.cairographics.org/releases/cairo-1.10.2.tar.gz'
  sha1 'ccce5ae03f99c505db97c286a0c9a90a926d3c6e'

  depends_on 'pkg-config' => :build
  depends_on 'pixman'

  keg_only :provided_by_osx,
            "The Cairo provided by Leopard is too old for newer software to link against."

  fails_with_llvm "Throws an 'lto could not merge' error during build.", :build => 2336

  def install
    ENV.append "LDFLAGS",  `pkg-config --libs-only-L pixman-1`.chomp
    ENV.append "CPPFLAGS",  `pkg-config --cflags-only-I pixman-1`.chomp
    ENV.x11
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-x
    ]
    args << '--enable-xcb' unless MacOS.leopard?

    system "./configure", *args
    system "make install"
  end
end
