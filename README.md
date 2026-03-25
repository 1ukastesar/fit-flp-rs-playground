# FLP Rust development playground

This repo provides a complete development environment for Rust & Jupyter labs in the FLP course at Brno University of Technology, Faculty of Information Technology. It uses the [EvCxR](https://github.com/evcxr/evcxr) Rust kernel for Jupyter, with Docker Compose and optionally VS Code Dev Containers for easy setup and development.

## Setup

1. **Install Docker**:

    a. For Windows and macOS, download and install Docker Desktop from [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop).

    b. For Linux, follow the instructions for your distribution at [https://docs.docker.com/engine/install/](https://docs.docker.com/engine/install/).

    *(Or)* Use this simple one-liner (beware of security implications):

```bash
curl -fsSL https://get.docker.com | sudo sh
```

2. **Clone the repository**:

```bash
git clone https://github.com/1ukastesar/fit-flp-rs-playground.git flp-rs-playground
cd flp-rs-playground
```

3. **Start the development environment**:

    a. Using Docker Compose (recommended):

    ```bash
    docker compose up -d
    ```

    > **Note:** The first run will build the Docker image, which includes compiling `evcxr_jupyter`. This may take several minutes.

    b. Using VS Code Dev Containers:

    - Open the repository folder in VS Code.
    - *(Recommended)* Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) if you haven't already.
    - When prompted, reopen the folder in the container.
    - If not prompted, you can manually open the Command Palette (`Ctrl+Shift+P`) and select `Dev Containers: Reopen in Container`.

4. **Set a Jupyter password**:

```bash
bash set-password.sh
```

## Accessing the Environment

- **VS Code Dev Container**: Once the container is running, you can create and edit files and use the integrated terminal in VS Code (`Ctrl+Shift+;`) to run Rust code and Jupyter notebooks.

- **Jupyter Notebook web interface**: Open [http://localhost:8888](http://localhost:8888) in your browser and log in with the password you set in step 4.

- **Cargo / rustc**: Run Rust tools interactively from the container shell:

```bash
# Docker Compose: run on host machine
docker compose exec devcontainer bash

# Dev Containers: integrated terminal
cargo --version
rustc --version
```

## Troubleshooting

- **Write permission denied in the `work` directory**

> [!IMPORTANT]
> You'll probably need to re-run these commands after adding any files to the `work/` directory from the host.

```bash
# on the host machine
sudo chmod -R 777 work

# or, if you wanna be better
docker compose exec -u 0 devcontainer chown -R jovyan:users ~jovyan/work
# and thanks to `userns_mode: host` in compose file it shouldn't break anything on host
```

- **Rust kernel not visible in Jupyter**

```bash
docker compose exec devcontainer evcxr_jupyter --install
docker compose exec devcontainer jupyter kernelspec list
```

## Docker image auto build and distribution (GitHub Actions)

Automated Docker pipelines are defined in:

- CI validation on pull requests: [.github/workflows/docker-ci.yml](.github/workflows/docker-ci.yml)
- Multi-arch image publishing to GHCR: [.github/workflows/docker-release.yml](.github/workflows/docker-release.yml)

### What gets published

- Registry: `ghcr.io`
- Image: `ghcr.io/<owner>/<repo>` (for this repo: `ghcr.io/1ukastesar/fit-flp-rs-playground`)
- Platforms: `linux/amd64`, `linux/arm64`
- Tags:
    - branch and git SHA tags
    - release tags from `v*`
    - `latest` for `main` and `v*` tags

### Security and supply chain features

- Vulnerability scanning with Trivy
- SBOM generation
- Build provenance attestations
- Keyless signing with Cosign (OIDC)

### How to trigger release images

1. Push to `main` (publishes `main`, `sha-*`, `latest`).
2. Create and push a git tag like `v1.2.3` (publishes semver tags + `latest`).
3. Or run the workflow manually from the Actions tab.

### Required repository settings

- Actions must be enabled for the repository.
- `GITHUB_TOKEN` must have package write access
  - Repo -> Settings -> Actions -> General -> Workflow permissions -> Check **Read and write permissions**
- In package settings, configure package visibility and access (private/public).
