{pkgs, ...}:
with pkgs; let
  fetchgit-no-verify =
    fetchgit
    // {
      __functor = self: args:
        (fetchgit.__functor self args).overrideAttrs (oldAttrs: {GIT_SSL_NO_VERIFY = true;});
    };
in rec {
  # mplus-fonts = pkgs.callPackage ./mplus-fonts { };
  spoofdpi = pkgs.callPackage ./spoofdpi {};
  hpb = pkgs.callPackage ./hpb {
    fetchgit = fetchgit-no-verify;
  };
}
