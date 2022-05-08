FROM ubuntu:20.04 as builder
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo sshfs bsdutils python3-dev \
    libpq-dev pkg-config zlib1g-dev libtool libtool-bin wget automake autoconf coreutils bison libacl1-dev \
    build-essential git \
    libffi-dev cmake libreadline-dev libtool netcat net-tools clang 


#RUN apt-get update && apt install lsb-release wget software-properties-common -y && \
#    wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && \
#    ./llvm.sh 11

COPY . /fragattacks

RUN cd /fragattacks/tests/fuzzing/json && \
    make clean && \ 
    CFLAGS="-fsanitize=fuzzer,address" CC=clang make LIBFUZZER=y && \
    cp json /fuzz_json_parser

FROM ubuntu:20.04
COPY --from=builder /fuzz_json_parser /
