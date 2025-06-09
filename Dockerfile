# nv_mambavision/Dockerfile
FROM nvcr.io/nvidia/pytorch:24.06-py3

# ------- build deps -------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git build-essential ninja-build && \
    rm -rf /var/lib/apt/lists/*

# ------- Python deps -------
RUN pip install --no-cache-dir \
        tensorboardX==2.6.2.2 \
        timm==1.0.9 einops==0.8.1 \
        transformers==4.50.0 requests==2.32.3 pillow==11.1.0

# ------- mamba-ssm (compile against current torch/cu) -------
RUN git clone --branch v2.2.4 --depth 1 https://github.com/state-spaces/mamba.git /tmp/mamba \
 && pip install --no-cache-dir --no-build-isolation /tmp/mamba \
 && rm -rf /tmp/mamba


# ------- copy repo & set workdir -------
WORKDIR /workspace/MambaVision
COPY . /workspace/MambaVision

ENV OMP_NUM_THREADS=8 \
    PYTHONUNBUFFERED=1

