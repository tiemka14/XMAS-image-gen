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

#RUN git clone https://github.com/facebookresearch/detectron2.git
#RUN python -m pip install -e detectron2
#RUN rm -rf /IDM-VTON/detectron2/.git

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
    pax-utils \
 && rm -rf /var/lib/apt/lists/*

# Detect onnxruntime .so and strip execstack protection
RUN sh -c "find /usr/local -name 'onnxruntime_pybind11_state*.so' -print -exec execstack -c {} \;" \
    || echo '⚠ onnxruntime execstack patch not applied (might be CPU build or different path)'

COPY rp_handler.py /IDM-VTON/
COPY app_wo_gradio.py /IDM-VTON/

ENV PYTHONPATH="/IDM-VTON:/IDM-VTON/gradio_demo:/IDM-VTON/gradio_demo/detectron2:/IDM-VTON/gradio_demo/densepose:$PYTHONPATH"

# Start the container
CMD ["python3", "-u", "rp_handler.py"]