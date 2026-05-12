{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, libcap
, libc
, pkg-config
, nix-update-script

# Optional dependencies / options.
, audit
, pam
, libselinux
, openssl
, withAudit ? true
, withBashCompletions ? true
, branding ? ""
, withNewnet ? true
, withPam ? true
, withSelinux ? false
, withSysVinit ? false
, withZshCompletions ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrc";
  version = "0.63.1";

  src = fetchFromGitHub {
    owner = "OpenRC";
    repo = "openrc";
    tag = finalAttrs.version;
    hash = "sha256-xfmwDSpBjXF3aykMJpqiv+/BLZJNbBge0+GYulEkiXo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  postPatch = ''
    sed -i 's/DESTDIR=/DESTDIR=\${DESTDIR:-}/g' tools/meson_final.sh
  '';

  #libcap is required for linux.
  buildInputs =
    lib.optional stdenv.hostPlatform.isLinux libcap
    ++ lib.optional stdenv.hostPlatform.isBSD libc
    ++ lib.optional withAudit audit
    ++ lib.optional withPam pam
    ++ lib.optional withSelinux libselinux
    ++ lib.optional (!withPam && withSelinux && !stdenv.hostPlatform.isBSD) openssl;

  mesonBuildType = "release";
  mesonFlags = [
    (lib.mesonOption "sysconfdir" "$(out)/etc")
    (lib.mesonEnable "audit" withAudit)
    (lib.mesonBool "bash-completions" withBashCompletions)
    (lib.mesonBool "newnet" withNewnet)
    (lib.mesonBool "pam" withPam)
    (lib.mesonEnable "selinux" withSelinux)
    (lib.mesonBool "sysvinit" withSysVinit)
    (lib.mesonBool "zsh-completions" withZshCompletions)
    (lib.mesonOption "branding" branding)
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^openrc-([0-9.]+)$" ];
  };

  meta = {
    description = "The OpenRC init system";
    homepage = "https://github.com/OpenRC/openrc";
    changelog = "https://github.com/OpenRC/openrc/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "openrc";
    platforms = lib.platforms.linux; #TODO: add kvm as a dependency and add freebsd support.
  };
})
