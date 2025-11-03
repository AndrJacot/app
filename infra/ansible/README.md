# Ansible README

## Prerequisites for macOS M1
- Install Docker Desktop manually: https://www.docker.com/products/docker-desktop/ (enable arm64 support if prompted). This allows Docker commands in CI workflows.
- Install Ansible via Homebrew: `brew install ansible`.
- Obtain GitHub runner registration token from your repo: Settings > Actions > Runners > New self-hosted runner > Copy token (select macOS and arm64 architecture).

## Usage
ansible-playbook -i inventories/local.ini playbooks/runner.yml --extra-vars "github_repo=<owner/repo> github_token=<token>"

This installs the native GitHub Actions runner for macOS arm64 (M1), registers it to your repo with labels 'dind,arm64', and starts it in the background using nohup.

The runner will use your host's Docker Desktop for any Docker-related jobs (e.g., builds in CI).

To monitor: tail -f ~/actions-runner/nohup.out

To stop: Kill the process (ps aux | grep run.sh) or remove and re-register via GitHub settings.

To remove: cd ~/actions-runner; ./config.sh remove --token <token>; rm -rf ~/actions-runner

Note: For persistent running across reboots, consider setting up a launchd plist manually (not automated here). Keep the terminal open or use tmux/screen for long-running sessions.

