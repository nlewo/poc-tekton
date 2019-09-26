let
  nixpkgs = builtins.fetchTarball {
    url = https://github.com/NixOS/nixpkgs-channels/archive/2dfae8e22fde5032419c3027964c406508332974.tar.gz;
    sha256 = "0293j9wib78n5nspywrmd9qkvcqq2vcrclrryxqnaxvj3bs1c0vj";
  };
  pkgs = import nixpkgs {};

  app = pkgs.stdenv.mkDerivation {
    name = "hello-world";
    unpackPhase = ":";
    buildInputs = [ pkgs.go ];
    buildPhase = ''
      go build -o hello-world ${./main.go}
    '';
    installPhase = ''
      install -Dm0755 hello-world $out/bin/hello-world
    '';
  };
  
in pkgs.dockerTools.buildImage {
  name = "hello-world";
  config = {
    CMD = [ "${app}/bin/hello-world" ];
  };
}
