# Use an official R base image
FROM r-base:latest

# Set maintainer information (optional)
LABEL maintainer="yourname@example.com"

# Set an environment variable to make the R script run in a non-interactive mode
ENV R_ENV=TRUE

# Update the system and install necessary Linux packages.
# This can include system libraries that R packages may depend on.
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional necessary R packages using the install.packages command
# Example: ggplot2 for plotting, httr for HTTP operations, etc.
RUN R -e "install.packages(c('ggplot2', 'httr'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

# Create a non-root user to run the R processes
# This is a security best practice to avoid running applications with root privileges
RUN useradd -m -s /bin/bash ruser
USER ruser

# Set the working directory
WORKDIR /home/ruser

# Copy any necessary scripts or files into the image
# For example, an R script that should run when the container starts
COPY ./scripts /home/ruser/scripts

# Command to run an R script that keeps the container running
# This script should be designed to run in a loop or wait indefinitely
CMD ["Rscript", "/home/ruser/scripts/run_forever.R"]

# run_forever.R is a dummy name, replace it with your actual R script name
# This script should be designed to not exit unless explicitly stopped
