#!/usr/bin/env bash
# utils.sh - Bibliothèque de fonctions utilitaires pour les scripts Bash

set -euo pipefail

# --- Création/répertoire ---
# crée le dossier s'il n'existe pas
ensure_dir() {
  local dir="$1"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
  fi
}

# --- détermine le type de fichier ---
get_type() {
    MIME_TYPE=$(file --mime-type -b "$1")
    case "$MIME_TYPE" in
        image/*) echo "images" ;;
        video/*) echo "videos" ;;
        audio/*) echo "audios" ;;
        *) echo "unknown" ;;
    esac
}

# --- Vérification de commandes ---
# quitte si la commande n'est pas trouvée
check_command() {
  local cmd="$1"
  if ! command -v "$cmd" &>/dev/null; then
    echo "[ERROR] Commande requise '$cmd' introuvable." >&2
    exit 2
  fi
}

# --- Lecture oui/non ---
# ask_yes_no <message> [default:N] : renvoie 0 si oui, 1 si non
ask_yes_no() {
  local prompt="$1"
  local default="${2:-N}"
  local reply
  while true; do
    read -p "$prompt [y/N] " reply
    reply="${reply:-$default}"
    case "$reply" in
      [Yy]*) return 0 ;;
      [Nn]*) return 1 ;;
      *) echo "Veuillez répondre par y ou n." ;;
    esac
  done
}

# --- Sélection dans un menu ---
# affiche les options, renvoie la chaîne choisie
select_option() {
  local prompt="$1"
  shift
  local options=("$@")
  local idx choice
  echo "$prompt"
  for idx in "${!options[@]}"; do
    printf "  %d) %s\n" $((idx+1)) "${options[idx]}"
  done
  while true; do
    read -p "Choix [1-${#options[@]}]: " choice
    if [[ "$choice" =~ ^[1-9][0-9]*$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
      echo "${options[$((choice-1))]}"
      return 0
    else
      echo "Sélection invalide."
    fi
  done
}

# --- Horodatage ---
# timestamp : renvoie YYYYMMDD-HHMMSS
timestamp() {
  date +%Y%m%d-%H%M%S
}
