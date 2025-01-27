# Lab Assignments (TTM4200, 2025)
This repository contains the lab assignments for the course TTM4200, spring 2025. 

<!-- Instructions for cloning the repository: -->
## Cloning the repository

We will use this repository to distribute the lab assignments. 

- To clone the repository, use the following command:

    ```bash
    git clone https://github.com/ntnuttm4200/2025_labs.git ~/labs
    ```
- We will update the repository with new assignments. To update your local copy, use the following command:

    ```bash
    cd ~/labs
    git add .
    git commit -m "Commit message"
    git pull origin main --no-edit
    ```

- You might need to set your username and email for git, when committing yor changes for the first time. To do this, use the following commands:

    ```bash
    git config --global user.name "Firstname Lastname"
    git config --global user.email "Your email"
    ```

# Lab assignments

The course consists of several lab assignments that will be published throughout the semester. These assignments are:

- [Lab 0 -- Server setup, Basics of Linux, and JupyterLab](lab0/)
- [Lab 1 -- Basic Tools: Docker, Docker Compose, Tcpdump, Wireshark, and Tmux](lab1/)
- [Lab 2 -- Application Layer: Web, Email, and DNS](lab2/)