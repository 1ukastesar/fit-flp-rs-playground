#!/bin/bash
printf "Password: " && read -rs pass && echo && \
printf '%s' "$pass" | docker compose exec -T devcontainer python3 -c "import sys; from jupyter_server.auth import passwd; print(passwd(sys.stdin.read()))" | \
xargs -I{} printf 'c.ServerApp.token = ""\nc.ServerApp.password = "{}"\n' > jupyter_server_config.py && \
docker compose restart devcontainer
