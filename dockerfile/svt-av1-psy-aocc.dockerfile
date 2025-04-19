# Use Arch Linux as the base image
FROM archlinux:latest

# Update the package database and install necessary packages
RUN pacman -Syu --noconfirm \
    git \
    base-devel \
    sudo \
    clang \
    cmake \
    lld \
    av1an \
    ffmpeg \
    --needed

# Clone and install yay (AUR helper)
RUN git clone https://aur.archlinux.org/yay.git /yay && \
    cd /yay && \
    makepkg -si --noconfirm && \
    rm -rf /yay

# Install aocc from AUR using yay
RUN yay -S --noconfirm aocc

# Set up AOCC environment and build svt-av1-psy
RUN bash -c "source /opt/aocc/setenv_AOCC.sh && \
    export CC=clang && \
    export CXX=clang++ && \
    export LD=lld && \
    git clone https://github.com/gianni-rosato/svt-av1-psy /svt-av1-psy && \
    cd /svt-av1-psy && \
    mkdir svt_build && cd svt_build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DSVT_AV1_LTO=OFF -DNATIVE=ON -DCMAKE_CXX_FLAGS=\"-flto=full\" -DCMAKE_C_FLAGS=\"-flto=full\" -DCMAKE_LD_FLAGS=\"-flto=full\" && \
    make -j$(nproc) && \
    sudo make install"

# Clean up (optional to reduce image size)
RUN rm -rf /svt-av1-psy

# Set the default command for the container
CMD ["/bin/bash"]
