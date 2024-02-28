set -g message-style "bg=yellow,fg=black"
set -g message-command-style "bg=black,fg=yellow"

set -g status-justify "left"

set -g status-style "bg=green,fg=black"

set -g status-left-length "10"
set -g status-right-length "40"

set -g status-left-style default
set -g status-right-style default

set -g status-left "[#{session_name}] "
set -g status-right "[#H] %Y-%m-%d %R"
