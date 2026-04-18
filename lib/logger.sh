# shellcheck shell=bash

log()   { printf "\n[+] %s\n" "$1"; }
warn()  { printf "\n[!] %s\n" "$1"; }
error() { printf "\n[x] %s\n" "$1" >&2; }
die()   { error "$1"; exit 1; }
