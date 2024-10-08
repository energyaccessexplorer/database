FROM ubuntu:latest

# Install dependencies, including PostgreSQL development headers
RUN apt-get update && apt-get install -y \
    make \
    bash \
    build-essential \
    git \
    postgresql-client \
    postgresql-server-dev-all

RUN git clone https://github.com/michelp/pgjwt.git \
    && cd pgjwt && make && make install && cd .. && rm -rf pgjwt

RUN pg_config --sharedir

# Set the working directory
WORKDIR /app

# Copy project files
COPY . .
