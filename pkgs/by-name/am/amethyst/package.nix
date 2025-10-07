{
  stdenv,
  lib,
  fetchFromGitHub,
  xmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "amethyst";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "frederoxdev";
    repo = "amethyst";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FSrsZh+N97Jot+tJD0BHwDBk+dL7w7ub97z9J5q6BDU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    xmake
  ];

  configurePhase = ''
    runHook preConfigurePhase

    mkdir $out
    xmake config --builddir=$out

    runHook postConfigurePhase
  '';

  buildPhase = ''
    runHook preBuildPhase

    xmake build

    runHook postBuildPhase
  '';

  meta = {
    description = "Minecraft Bedrock Modding Framework.";
    homepage = "https://github.com/FrederoxDev/Amethyst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    platforms = lib.platforms.all;
  };
})
