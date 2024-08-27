# Start with a base image
FROM debian:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    bmake \
    postgresql \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV POSTGRES_DB=ea_dev

# Set up PostgreSQL with specified user, password, and database
USER postgres
RUN /etc/init.d/postgresql start && \
    psql --command "ALTER USER postgres WITH PASSWORD 'postgres';" && \
    createdb -O postgres ea_dev

# Expose PostgreSQL port
EXPOSE 5432

# Start PostgreSQL service by default
CMD ["/usr/lib/postgresql/15/bin/postgres", "-D", "/var/lib/postgresql/15/main", "-c", "config_file=/etc/postgresql/15/main/postgresql.conf"]
