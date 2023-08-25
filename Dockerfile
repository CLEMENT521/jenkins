# Use a base image with Ubuntu as the OS
FROM ubuntu:latest

# Update and install basic dependencies
RUN apt-get update && apt-get install -y sudo nano vim zip unzip net-tools curl

# Install Bash shell and tab-completion support
RUN apt-get update && apt-get install -y bash-completion

# Create a new user (replace "newuser" with your desired username)
RUN useradd -ms /bin/bash psg

# Set a password for the new user (replace "password" with your desired password)
RUN echo 'psg:psg' | chpasswd

# Add the new user to the sudo group
RUN usermod -aG sudo psg

# Set working directory
WORKDIR /home/psg

# Install OpenSSH server
RUN apt-get update && apt-get install -y openssh-server

# Expose SSH port
EXPOSE 22


# Install OpenSSH client and tools
#RUN apk update && apk add openssh-client

# Set timezone using timedatectl
#RUN timedatectl

# Create a systemd service (replace "your-service-name" with the desired service name)
RUN echo "[Unit]\nDescription=Sample systemd service\n\n[Service]\nType=simple\nExecStart=/bin/sleep infinity" > /etc/systemd/system/ssh.service

# Reload systemd after adding the service
#RUN systemctl daemon-reload

# Enable the newly created service
RUN systemctl enable ssh.service

# Run some commands to demonstrate the use of timectl, systemctl, ssh, chown, and echo
RUN echo "Hello, Docker!" > hello.txt
RUN chown psg:psg hello.txt
RUN echo "This is a test." > test.txt
RUN ssh -V
RUN echo "This is a second test." >> test.txt
RUN echo "Dockerfile execution complete."

# Install Node Version Manager (nvm)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Load nvm without restarting shell
RUN /bin/bash -c "source ~/.nvm/nvm.sh && nvm install node"

# Install Chrome (you might need to adjust the version and URL)
#RUN curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o chrome.deb
#RUN sudo dpkg -i chrome.deb || sudo apt-get -f install -y
#RUN rm chrome.deb

# Create a sample directory and move a file
RUN mkdir sample_dir && echo "Hello, Docker!" > sample_dir/sample_file.txt
RUN mv sample_dir/sample_file.txt .

# Install wget, git, and curl
RUN apt-get update && apt-get install -y wget git curl

# Create a directory for cloning
WORKDIR /app

# Clone a sample repository using git
RUN git clone https://github.com/example/sample-repo.git

# Run wget to download a file
RUN wget https://example.com/sample-file.txt -O /app/sample-file.txt

# Run curl to download another file
RUN curl -o /app/another-sample-file.txt https://example.com/another-sample-file.txt

# Run a simple test to demonstrate the presence of wget and curl
RUN wget --version && curl --version

# Run a nohup command (this will not produce meaningful output in the Docker build context)
RUN echo "echo 'Running nohup command'" > nohup_script.sh && chmod +x nohup_script.sh
RUN nohup ./nohup_script.sh &

# Install npm package (replace "your-package-name" with an actual package)
RUN /bin/bash -c "source ~/.nvm/nvm.sh && npm install -g your-package-name"

# Expose ports if needed
EXPOSE 80 443

# Start a shell session
CMD ["/bin/bash"]
