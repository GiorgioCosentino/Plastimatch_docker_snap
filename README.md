# Plastimatch_docker_snap

## Description

This repository provides an automated way to build a Snap package of **Plastimatch** using Docker and Snapcraft.  
The package can then be installed on any Linux system with Snap support.

---

### Requirements

- [Docker](https://docs.docker.com/engine/) – needed to build the Snap inside a container
- [Snapd](https://snapcraft.io/docs/installing-snapd) – needed to install the generated Snap package

---

### Build the Snap Package

Run the following command  to build the snap:

```bash
docker run -it --rm --entrypoint /bin/bash --name build_plastimatch -v $PWD:/build -w /build ghcr.io/canonical/snapcraft:8_core24 /build/build_snap.sh
```

After completion, you will find the `plastimatch_*.snap` file in your local repository folder.

---

### Install the Snap Package

Once the build is done, install the generated package with:

```bash
sudo snap install plastimatch_*.snap --dangerous
```

**Note:**  
The `--dangerous` flag is required because the package was built locally and is not signed by the official Snap store.


