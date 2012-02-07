# Mint staging/dev servers
bp() {
    ssh mint@briarpatch-0${1}.vm.brightbox.net
}
by() {
    ssh mint@briaryear-0${1}.vm.brightbox.net
}
ms() {
  ssh mintstaging-0${1}.vm.brightbox.net
}