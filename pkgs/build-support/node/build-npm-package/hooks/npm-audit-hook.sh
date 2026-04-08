# shellcheck shell=bash

npmAuditHook() {
    echo "Executing npmAuditHook"

    runHook preBuild

    commannd=$(npm audit run ${npmWorkspace+--workspace=$npmWorkspace} $npmAuditFlags "${npmAuditFlagsArray[@]}" $npmFlags "${npmFlagsArray[@]}")

    runHook postBuild

    echo "Finished npmAuditHook"
}

if [ ! -v "${runNpmAudit-}" ]; then
  checkPhase+=(npmAuditHook)
fi
