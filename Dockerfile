FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt-get update \
    && apt-get install -y \
    python3.10 \
    python3.10-distutils \
    python3.10-dev \
    python3.10-venv \
    wget \
    git \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.10 1

# Manually install pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# Ensure we're using the correct pip
RUN python3 -m pip install --upgrade pip

# Install NumPy with a specific version
RUN python3 -m pip install numpy==1.24.3

# Install PyTorch and torchvision with updated versions
RUN python3 -m pip install torch==1.13.1 torchvision==0.14.1 --extra-index-url https://download.pytorch.org/whl/cpu

# Clone the latest Real-ESRGAN repository
RUN git clone https://github.com/xinntao/Real-ESRGAN.git /real-esrgan
WORKDIR /real-esrgan
RUN python3 -m pip install -r requirements.txt
RUN python3 setup.py develop

# Set the working directory to /app
WORKDIR /app

# Set PYTHONPATH to include the Real-ESRGAN directory
ENV PYTHONPATH=/real-esrgan:$PYTHONPATH

ENTRYPOINT ["python3", "up_scale.py"]