return {
  check_device = "hyprctl devices | grep -E -x \"$(printf '\\t\\t%s')\"";
  lang_codes = "hyprctl devices | grep -A1 %s | grep -o 'l \"[^\"]*\"' | cut -d'\"' -f2";
  current_layout = "hyprctl devices | grep -A2 %s | grep 'active keymap: ' | cut -d' ' -f3-"
}
