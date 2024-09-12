{
  lib,
  pkgs,
  version ? "v0.11.1",
  hash ? "sha256-GdGOnaIDy7XWWo0MOu+HfQcLrW/PDlRxf0y1jjJrZNQ=",
  vendorHash ? "sha256-47Gt5SI6VXq4+1T0LxFvQoYNk+JqTt3DonDXLfmFBzw=",
  ...
}:
pkgs.buildGoModule {
  pname = "spoofdpi";
  inherit version;

  src = pkgs.fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = version;
    hash = hash;
  };

  inherit vendorHash;

  doCheck = false;

  ldflags = ["-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs"];

  meta = with lib; {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "A simple and fast anti-censorship tool written in Go";
    license = licenses.asl20;
    maintainers = with bonLib.maintainers; [L-Nafaryus];
    broken = false;
    mainProgram = "spoofdpi";
  };
}
