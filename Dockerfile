
# Use the official Ubuntu image from Docker Hub as
# a base image
FROM ubuntu:24.04

# Execute next commands in the directory /workspace
WORKDIR /workspace

# Copy over the script to the /workspace directory
COPY config/ ./config/
COPY script/ ./script/

# Just in case the script doesn't have the executable bit set
RUN chmod +x ./script/*.sh

# Run the script when starting the container
CMD [ "./script/sample.sh" ]