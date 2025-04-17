# env.nu
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu

$env.OS = (sys host).name
use std/util "path add"
mut zlua_path = "~/bin/z.lua"

if $env.OS == "Windows" {
    $zlua_path = "D:/tool/scoop/apps/z.lua/current/z.lua"
} else {
    path add $"($env.HOME)/go/bin"
    path add $"($env.HOME)/bin"
}
$env.PATH = ($env.PATH | uniq)

if (which atuin | is-not-empty) {
    atuin init nu --disable-up-arrow | save -f ($nu.default-config-dir | path join "atuin.nu")
}

if ($zlua_path | path expand | path exists) {
    lua ($zlua_path | path expand) --init nushell | save -f ($nu.default-config-dir | path join "zlua.nu")
}
