# Container Manager Plugin for Noctalia

A plugin to manage Docker containers and volumes directly from your Noctalia bar.

## Features

- **Bar Widget**: Shows the number of running containers
- **Container Management**: List all containers with status, start/stop/remove options
- **Volume Management**: List volumes and remove them
- **Cleanup Operations**: Prune stopped containers and unused volumes
- **Auto Refresh**: Configurable refresh interval for live updates

## Installation

This plugin is part of the `noctalia-plugins` repository.

## Configuration

Access the plugin settings in Noctalia to configure:

- **Refresh Interval**: How often to update the container and volume lists (1-30 seconds)

## Usage

- The Docker icon with running container count appears on your bar
- Click to open the management panel
- Switch between Containers and Volumes tabs
- Use buttons to manage individual items or perform bulk cleanup

## Requirements

- Noctalia 3.6.0 or later
- Docker installed and running
