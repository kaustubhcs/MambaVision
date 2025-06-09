#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Launch MambaVision training/profiling container on a Jarvis Labs H100 VM
# Everything (images, logs) stays under your $HOME directory.
# -----------------------------------------------------------------------------

set -euo pipefail

# ---- user-adjustable paths on the HOST --------------------------------------
DATA_DIR="$HOME/datasets/imagenet"        # ImageNet tree or LMDB
SRC_DIR="$HOME/MambaVision"               # repo you cloned / edited
LOG_DIR="$HOME/mamba_logs"                # will be created if missing
IMG_NAME="nv_mambavision:latest"          # Docker image tag you built
CONTAINER_NAME="mamba_train"              # friendly name for docker ps

mkdir -p "$LOG_DIR"

# ---- docker run -------------------------------------------------------------
docker run --rm -it \
	  --gpus all \
	    --ipc=host --shm-size=64g \
	      -e NVIDIA_DRIVER_CAPABILITIES=all \
	        -v "${DATA_DIR}":/datasets/imagenet \
		  -v "${SRC_DIR}":/workspace/MambaVision \
		    -v "${LOG_DIR}":/workspace/logs \
		      --name "${CONTAINER_NAME}" \
		        "${IMG_NAME}" /bin/bash

# When the container exits it’s automatically removed (--rm).

