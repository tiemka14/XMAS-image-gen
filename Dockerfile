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

COPY requirements.txt /IDM-VTON/

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip cache purge

COPY rp_handler.py /IDM-VTON/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]