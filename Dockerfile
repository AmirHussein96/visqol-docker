FROM ubuntu:22.04

# ------------------------------------------------------
# Install system dependencies
# ------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    cmake \
    wget \
    unzip \
    curl \
    openjdk-11-jdk \
    pkg-config \
    libssl-dev \
    libsndfile1 \
    libsndfile1-dev \
    libsox-dev \
    sox \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get clean

# ------------------------------------------------------
# Install Python deps BEFORE Bazel (required by python_configure)
# ------------------------------------------------------

RUN pip3 install --upgrade pip
RUN pip3 install numpy six soundfile
# ------------------------------------------------------
# Install Bazel (required for ViSQOL build)
# ------------------------------------------------------
#RUN wget https://github.com/bazelbuild/bazel/releases/download/5.1.0/bazel-5.1.0-installer-linux-x86_64.sh \
#    && chmod +x bazel-5.1.0-installer-linux-x86_64.sh \
#    && ./bazel-5.1.0-installer-linux-x86_64.sh --user \
#    && ln -s /root/bin/bazel /usr/local/bin/bazel

RUN wget https://github.com/bazelbuild/bazel/releases/download/5.3.2/bazel-5.3.2-installer-linux-x86_64.sh \
    && chmod +x bazel-5.3.2-installer-linux-x86_64.sh \
    && ./bazel-5.3.2-installer-linux-x86_64.sh --user \
    && ln -s /root/bin/bazel /usr/local/bin/bazel

# ------------------------------------------------------
# Clone and build ViSQOL
# ------------------------------------------------------

RUN git clone https://github.com/google/visqol.git /opt/visqol
WORKDIR /opt/visqol

RUN bazel build :visqol -c opt

RUN find /root/.cache/bazel -type f -name "visqol" -exec cp {} /usr/local/bin/visqol \;
RUN chmod +x /usr/local/bin/visqol

# ------------------------------------------------------
# Install ViSQOL Python package (this builds Python bindings)
# ------------------------------------------------------
RUN pip3 install google
RUN pip3 install googleapis-common-protos
RUN pip3 install .

RUN pip install git+https://github.com/descriptinc/descript-audio-codec
# Container default working directory
WORKDIR /workspace

CMD ["bash"]
