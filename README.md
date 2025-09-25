# Plastimatch_docker_snap

## Description

This repository provides a simple and automated way to build a Snap package of **Plastimatch** that is always up-to-date with the latest commit from the official repository. By using Docker and Snapcraft, you can build the package in an isolated and reproducible environment, without needing to manually install all dependencies on your system.

The resulting Snap package allows you to easily install Plastimatch on any Linux system that supports Snap, ensuring you always have the newest available version.

---

## How It Works

1. **Repository Contents:**
   - `build_snap.sh`: The main script that manages the Snap package build process inside a Docker container.
   - The resulting Snap package (`plastimatch_*.snap`) is saved directly in the repository folder after the build process.

2. **Automated Workflow:**
   - Launches a dedicated Docker container with Snapcraft already set up.
   - Executes the `build_snap.sh` script, which pulls the latest Plastimatch source from the official repository, builds the Snap package, and places it in your local repo folder.

---

## Installation and Usage Guide

### Prerequisites

- **Docker** installed on your system: [Docker Installation Guide](https://docs.docker.com/engine/)
- **Snapd** installed on your system: [Snapd Installation Guide](https://snapcraft.io/docs/installing-snapd)

---

### 1. Clone the Repository

```bash
git clone https://github.com/GiorgioCosentino/Plastimatch_docker_snap.git
cd Plastimatch_docker_snap
```

---

### 2. Build the Snap Package

Run the following command from the repository folder:

```bash
docker run -it --rm --entrypoint /bin/bash --name build_plastimatch -v $PWD:/build -w /build ghcr.io/canonical/snapcraft:8_core24 /build/build_snap.sh
```

**What does this command do?**
- Starts a Docker container with Snapcraft pre-installed.
- Mounts your current directory inside the container.
- Runs the `/build/build_snap.sh` script, which automatically builds the Snap package from the latest Plastimatch commit.
- After completion, you will find the `plastimatch_*.snap` file in your local repository folder.

---

### 3. Install the Snap Package

Once the build is done, install the generated package with:

```bash
sudo snap install plastimatch_*.snap --dangerous
```

**Note:**  
The `--dangerous` flag is required because the package was built locally and is not signed by the official Snap store.

---

## Updates

To always have the latest version of Plastimatch:
- Simply rerun the Docker command to regenerate an updated Snap package.

---

## FAQ

- **Can I use this method on any Linux system?**  
  Yes, as long as `docker` and `snapd` are installed.

- **Where will the generated Snap package be stored?**  
  In your local repository folder after the Docker container finishes building.

- **Does this always fetch the latest Plastimatch version?**  
  Yes, the `build_snap.sh` script clones the latest commit from the official repository.

---

## References

- [Plastimatch Official Repository](https://gitlab.com/plastimatch/plastimatch)
- [Snapcraft Documentation](https://snapcraft.io/docs)
- [Docker Documentation](https://docs.docker.com/engine/)

---

## Contact

For questions or suggestions, please open an Issue in this repository.
