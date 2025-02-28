FROM ubuntu

RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="America/New_York" apt-get install -y tzdata
RUN apt-get install -y cmake git
RUN apt-get install -y libssl-dev librtlsdr-dev libusb-1.0-0-dev pkg-config debhelper
RUN git clone https://github.com/Joseph-Melberg/rabbitmq-c
RUN cd rabbitmq-c && git checkout 23856b8cce06d0ed0a4e65f46bde27df409fe9f6
RUN cd rabbitmq-c && mkdir build && cd build
WORKDIR /rabbitmq-c/build
RUN cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
RUN cmake --build . --target install

WORKDIR /dump1090-mutability
COPY . .
RUN make clean
RUN make
RUN export LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu
RUN chmod +x Start.sh

EXPOSE 30004
EXPOSE 8080

ENTRYPOINT [ "/dump1090-mutability/Start.sh" ]
