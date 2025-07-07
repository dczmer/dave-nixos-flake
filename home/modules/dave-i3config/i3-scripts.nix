{
  packages,
  ...
}:
with packages;
stdenv.mkDerivation {
  src = ./.;
  pname = "dave-i3config";
  version = "0.1";
  buildPhase = ''
    runHook preBuild
    mkdir -p $out
    cp -r bin $out
    set -x
    runHook postBuild
  '';
}
