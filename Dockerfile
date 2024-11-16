FROM elixir:1.14-slim

# Install necessary dependencies
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# Install Hex and Rebar
RUN mix local.hex --force && mix local.rebar --force

# Set working directory
WORKDIR /app

# Copy project files
COPY mix.exs mix.lock ./
RUN mix deps.get

COPY . .

# Expose application port
EXPOSE 4000

# Run the application
CMD ["mix", "phx.server"]
