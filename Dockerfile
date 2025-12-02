FROM python:3.10-slim

WORKDIR /

RUN git clone https://github.com/yisol/IDM-VTON.git

WORKDIR /IDM-VTON

RUN conda env create -f environment.yaml
RUN conda activate idm
RUN pip install --no-cache-dir runpod

COPY rp_handler.py /

# Start the container
CMD ["python3", "-u", "rp_handler.py"]