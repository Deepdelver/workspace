---
id: home-assistant
title: Home Assistant
type: synthesis
updated: 2026-04-17
---

# Home Assistant

Open-source home automation platform that puts local control and privacy first.

## Overview

Home Assistant is a Python-based open-source home automation platform that runs locally (no cloud required), integrates with thousands of devices and services, and provides a powerful automation engine.

**Website:** https://www.home-assistant.io

## Core Features

- **Automations** - Trigger-based actions using triggers, conditions, and actions
- **Dashboards** - Customizable UI with various card types (entities, lights, climate, etc.)
- **Voice Assistants** - Built-in Assist for local voice control
- **Energy Management** - Track electricity, solar, batteries, gas, and water
- **Integrations** - Connect to thousands of devices via official integrations

## Documentation Structure

### Automations
- Basic automations, triggers, conditions, actions
- Automation editor (GUI and YAML)
- Blueprints for reusable automation templates
- Scripts for complex sequences
- Templates for dynamic values

### Dashboards
- Multiple view types: Masonry, Panel, Sections (default), Sidebar
- 30+ card types: Entities, Light, Climate, History Graph, Map, Media Control, etc.
- Custom cards and dashboard actions

### Voice Assistants
- **Assist** - Built-in local voice assistant
- Wake words: Local or cloud-based options
- ESP32-S3-BOX, custom hardware setups
- Custom sentences and AI personalities

### Organization
- Areas and Floors for device grouping
- Labels and Categories for organization
- Tables for structured data

### Advanced Configuration
- YAML configuration syntax
- Packages for modular configs
- Secrets management
- Remote access configuration

### Integrations
- MQTT broker integration
- 1000+ official integrations
- Custom components support

### Tools
- Developer tools for debugging
- Configuration validator (check_config)
- Quick search

## Hardware

Official hardware options:
- **Home Assistant Green** - Plug-and-play starter kit
- **Home Assistant Yellow** - Advanced option with Zigbee/Thread
- **Home Assistant Connect ZBT-1** - Zigbee/Thread radio
- **Home Assistant Connect ZBT-2** - Matter support
- **Home Assistant Connect ZWA-2** - Z-Wave radio
- **Home Assistant Voice Preview Edition** - Voice assistant hardware

## Installation

Multiple installation options:
- Home Assistant Operating System (recommended)
- Home Assistant Container (Docker)
- Home Assistant Core (Python)

## Notes

- Frank has Home Assistant running at https://deepdelver.duckdns.org:8123
- SSH access: `ssh root@192.168.1.251`
- Uses Long-Lived Access Token for API authentication

## Summary

Home Assistant is the core home automation platform. It provides:
- Local-first operation with no cloud dependency
- Extensive device integration ecosystem
- Powerful automation and scripting capabilities
- Customizable dashboards and UI
- Built-in voice assistant (Assist)
- Energy management features
- Strong community and documentation

For more details, see the [official documentation](https://www.home-assistant.io/docs/).