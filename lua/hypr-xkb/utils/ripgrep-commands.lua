return {
  check_device = "hyprctl devices | rg -x '\\t\\t%s'";
  lang_codes = "hyprctl devices | rg -A1 %s | rg -o 'l \"([^\"]+)\"' | cut -d'\"' -f2";
  current_layout = "hyprctl devices | rg -A2 %s | rg 'active keymap: ' -r '$1' | sed 's/^[[:space:]]*//'"
}
