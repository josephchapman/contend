#!/usr/bin/env bash
set -euo pipefail

VENV_PATH=${VENV_PATH:-/opt/devcontainer-venv}

apt update

# iproute2 is required for `ss` for `postStartCommand`
apt install -y --no-install-recommends \
  iproute2 \
  python3 \
  python3-pip \
  python3-venv \
  openjdk-17-jre-headless

mkdir -p "${VENV_PATH}"
python3 -m venv "${VENV_PATH}"
source "${VENV_PATH}/bin/activate"

python -m pip install --upgrade pip
python -m pip install --no-cache-dir \
  jupyterlab \
  numpy \
  pandas \
  pyspark

tee /usr/local/bin/start-jupyter.sh 2>&1 > /dev/null \
<<'EOF'
#!/usr/bin/env bash
set -euo pipefail

VENV_PATH=${VENV_PATH:-/opt/devcontainer-venv}

exec "${VENV_PATH}/bin/jupyter" lab \
  --ip 0.0.0.0 \
  --port=8888 \
  --no-browser \
  --allow-root \
  --NotebookApp.token='' \
  --NotebookApp.password='' \
  --NotebookApp.disable_check_xsrf=True \
  --NotebookApp.allow_remote_access=True
EOF
chmod +x /usr/local/bin/start-jupyter.sh
  