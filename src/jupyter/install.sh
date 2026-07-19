#!/usr/bin/env bash
set -euo pipefail

VENV_PATH=${VENV_PATH:-/opt/devcontainer-venv}
ENABLE_K8S_CLUSTER_FOR_PYSPARK_WORKERS=${ENABLE_K8S_CLUSTER_FOR_PYSPARK_WORKERS:-true}
K8S_API_SERVER_URL=${K8S_API_SERVER_URL:-https://127.0.0.1:6443}
SPARK_K8S_CONTAINER_IMAGE=${SPARK_K8S_CONTAINER_IMAGE:-apache/spark:4.1.2-java17}

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
  ipykernel \
  numpy \
  pandas \
  pyspark

python -m ipykernel install --sys-prefix --name python3 --display-name "Python 3 (ipykernel)"

if [ "${ENABLE_K8S_CLUSTER_FOR_PYSPARK_WORKERS}" = "true" ]; then
  tee /etc/profile.d/pyspark-k8s-cluster.sh 2>&1 > /dev/null \
<<EOF
export PYSPARK_K8S_API_SERVER="${K8S_API_SERVER_URL}"
export PYSPARK_SUBMIT_ARGS="--master k8s://${K8S_API_SERVER_URL} --conf spark.kubernetes.container.image=${SPARK_K8S_CONTAINER_IMAGE} pyspark-shell"
EOF
else
  tee /etc/profile.d/pyspark-k8s-cluster.sh 2>&1 > /dev/null \
<<EOF
export PYSPARK_SUBMIT_ARGS="--master local[*] pyspark-shell"
EOF
fi
chmod +x /etc/profile.d/pyspark-k8s-cluster.sh

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
  