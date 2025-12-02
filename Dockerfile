FROM python:3.10-slim

WORKDIR /

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/yisol/IDM-VTON.git

WORKDIR /IDM-VTON

# Convert conda env to pip
RUN grep -A1000 "pip:" environment.yaml | sed '1d' | sed '/^name:/d' | sed '/^dependencies:/d' | sed 's/- //' > requirements.txt

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

RUN pip install --no-cache-dir runpod

COPY rp_handler.py /IDM-VTON/

# Start the container
CMD ["python3", "-u", "rp_handler.py"]