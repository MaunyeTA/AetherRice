set -g fish_greeting ""
if status is-interactive
    fastfetch
end
eval (starship init fish)