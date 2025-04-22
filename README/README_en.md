# gcloud-env

A tool to manage multiple Google Cloud SDK configurations per project directory, similar to how asdf manages runtime versions.

## Problem

When working with multiple Google Cloud projects, switching between different gcloud configurations can be cumbersome. The `gcloud config configurations` command helps, but it's global and not tied to specific project directories.

## Solution

`gcloud-env` allows you to:

1. Create and manage separate gcloud configurations for each of your projects
2. Automatically switch between configurations when you change directories
3. Keep your Google Cloud credentials and settings isolated between projects

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/gcloud-env.git
   ```

2. Add the bin directory to your PATH:
   ```bash
   echo 'export PATH="$PATH:/path/to/gcloud-env/bin"' >> ~/.bashrc
   # or for zsh
   echo 'export PATH="$PATH:/path/to/gcloud-env/bin"' >> ~/.zshrc
   ```

3. Set up the auto-switching functionality by adding to your shell configuration:
   ```bash
   # gcloud-env setup
   source /path/to/gcloud-env/bin/gcloud-env
   ```

4. Reload your shell configuration:
   ```bash
   source ~/.bashrc
   # or for zsh
   source ~/.zshrc
   ```

## Usage

### Initialize a new configuration for a project

Navigate to your project directory and initialize a new configuration:

```bash
cd /path/to/your/project
gcloud-env init my-project-config
```

This will:
- Create a new configuration named `my-project-config`
- Copy your current gcloud settings to this configuration (if any)
- Create a `.gcloud-env` file in your project directory

### Switch between configurations

To manually switch to a specific configuration:

```bash
gcloud-env use my-project-config
```

With the auto-switching functionality enabled, simply changing to a directory with a `.gcloud-env` file will automatically switch to the specified configuration.

### List available configurations

```bash
gcloud-env list
```

### Show current configuration

```bash
gcloud-env current
```

### Delete a configuration

```bash
gcloud-env delete my-project-config
```

This will delete the specified configuration. Note that you cannot delete the currently active configuration.

### Get help

```bash
gcloud-env help
```

## How it works

`gcloud-env` works by:

1. Storing different gcloud configurations in `~/.config/gcloud-env/`
2. Creating a symlink from `~/.config/gcloud` to the active configuration
3. Using a `.gcloud-env` file in each project directory to specify which configuration to use
4. Providing a shell hook that automatically switches configurations when changing directories

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](../LICENSE.md) file for details.
