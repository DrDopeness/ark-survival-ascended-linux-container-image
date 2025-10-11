FROM opensuse/tumbleweed

# Install all packages from appliance.kiwi
RUN zypper -n refresh && \
    zypper -n install \
    patterns-base-base \
    glibc-locale-base \
    timezone \
    libgcc_s1-32bit \
    python3 \
    wget \
    tar \
    libfreetype6 \
    unzip \
    ruby \
    ruby-devel \
    make \
    gcc-c++ \
    && zypper clean -a

# Copy everything from root
COPY root/ /

# Run the config.sh if it exists
COPY config.sh /tmp/config.sh
RUN chmod +x /tmp/config.sh && /tmp/config.sh || true

# Create user and directories
RUN useradd -m -u 25000 -g users gameserver || true && \
    mkdir -p /home/gameserver/steamcmd && \
    mkdir -p /home/gameserver/Steam && \
    mkdir -p /home/gameserver/server-files && \
    mkdir -p /home/gameserver/cluster-shared && \
    chmod +x /usr/bin/start_server && \
    chmod +x /usr/bin/cli-asa-mods && \
    chown -R gameserver:users /home/gameserver

# Install Ruby gems if needed
RUN gem install json || true

USER gameserver
WORKDIR /home/gameserver
ENTRYPOINT ["/usr/bin/start_server"]
