FROM nvcr.io/nvidia/l4t-base:r32.6.1

# commands run in order from:
# https://docs.google.com/document/d/1Gy4CEKjqXZub0rz-YmxFOakj9O_ZjMmlUYe7NLdM4FY/edit
# starting at "DonkeyCar AI Framework"

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y build-essential python3 \
    python3-dev python3-pip libhdf5-serial-dev hdf5-tools \
    libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev \
    libblas-dev gfortran libxslt1-dev libxml2-dev \
    libffi-dev libcurl4-openssl-dev libssl-dev libpng-dev \
    libopenblas-dev openmpi-doc openmpi-bin libopenmpi-dev \
    libopenblas-dev git nano

RUN pip3 install Jetson.GPIO

# omitting user modifications

RUN cd ~ && mkdir projects && cd projects && \
    mkdir envs && cd envs && pip3 install virtualenv

RUN python3 -m virtualenv -p python3 ~/projects/envs/donkey \
    --system-site-packages

RUN echo "source ~/projects/envs/donkey/bin/activate" >> ~/.bashrc

# RUN . ~/.bashrc

RUN . ~/projects/envs/donkey/bin/activate
    pip3 install -U pip testresources setuptools && \
    pip3 install -U futures==3.1.1 protobuf==3.12.2 pybind11==2.5.0 && \
    pip3 install -U cython==0.29.21 pyserial && \
    pip3 install -U future==0.18.2 mock==4.0.2 h5py==2.10.0 \
    keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.3.3 && \
    pip3 install -U absl-py==0.9.0 py-cpuinfo==7.0.0 psutil==5.7.2 \
    portpicker==1.3.1 six requests==2.24.0 astor==0.8.1 \
    termcolor==1.1.0 wrapt==1.12.1 google-pasta==0.2.0 && \
    pip3 install -U gdown

RUN pip3 install pycuda

RUN cd ~/projects && wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whlcp p57jwntv436lfrd78inwl7iml6p13fzh.whl torch-1.8.0-cp36-cp36m-linux_aarch64.whl && \
    pip3 install torch-1.8.0-cp36-cp36m-linux_aarch64.whl && \
    apt-get install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev && \
    git clone -b v0.9.0 https://github.com/pytorch/vision torchvision && \
    cd torchvision && \
    python setup.py install &&\
    cd ../

RUN cd ~/projects && git clone https://github.com/autorope/donkeycar && \
    cd donkeycar && \
    git checkout master

RUN cd ~/projects/donkeycar && donkey createcar --path ~/projects/d3

RUN apt-get install -y python3-dev python3-numpy \
    python-dev libsdl-dev libsdl1.2-dev \
    libsdl-image1.2-dev libsdl-mixer1.2-dev \
    libsdl-ttf2.0-dev libsdl1.2-dev libsmpeg-dev \
    python-numpy subversion libportmidi-dev ffmpeg \
    libswscale-dev libavformat-dev libavcodec-dev \
    libfreetype6-dev libswscale-dev libjpeg-dev libfreetype6-dev
