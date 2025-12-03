FROM python:3.10-slim

WORKDIR /

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/yisol/IDM-VTON.git
RUN rm -rf /IDM-VTON/.git

WORKDIR /IDM-VTON

RUN pip install torch==2.0.1+cu118 \
    torchvision==0.15.2+cu118 \
    torchaudio==2.0.2+cu118 \
    -f https://download.pytorch.org/whl/torch_stable.html

RUN apt-get update && apt-get install -y build-essential

RUN pip install \
    https://dl.fbaipublicfiles.com/detectron2/wheels/cu118/torch2.0/index.html \
    --no-cache-dir

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge

RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
 && rm -rf /var/lib/apt/lists/*

COPY rp_handler.py /IDM-VTON/
COPY app_wo_gradio.py /IDM-VTON/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]