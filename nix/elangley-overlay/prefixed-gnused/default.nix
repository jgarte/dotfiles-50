{ pkgs ? import <nixpkgs> {}, lib ? pkgs.lib, stdenv ? pkgs.stdenv , fetchurl ? pkgs.fetchurl , perl ? pkgs.perl }:

stdenv.mkDerivation rec {
  pname = "gnused-prefixed";
  version = "4.8";

  src = fetchurl {
    url = "mirror://gnu/sed/sed-${version}.tar.xz";
    sha256 = "0cznxw73fzv1n3nj2zsq6nf73rvsbxndp444xkpahdqvlzz0r6zp";
  };

  outputs = [ "out" "info" ];
  configureFlags = [ "--program-prefix=g" ];

  nativeBuildInputs = [ perl ];
  preConfigure = "patchShebangs ./build-aux/help2man";

  # Prevents attempts of running 'help2man' on cross-built binaries.
  PERL = if stdenv.hostPlatform == stdenv.buildPlatform then null else "missing";

  meta = {
    homepage = "https://www.gnu.org/software/sed/";
    description = "GNU sed, a batch stream editor";

    longDescription = ''
      Sed (stream editor) isn't really a true text editor or text
      processor.  Instead, it is used to filter text, i.e., it takes
      text input and performs some operation (or set of operations) on
      it and outputs the modified text.  Sed is typically used for
      extracting part of a file using pattern matching or substituting
      multiple occurrences of a string within a file. This version installs sed
      with a `g` program prefix, for use on macOS.
    '';

    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
