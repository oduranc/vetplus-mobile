# Vetplus Mobile

Mobile Flutter application for college final project Vetplus.

## Prerequisites

1. Flutter vscode extension
2. Flutter SDK

## How to run

1. Install the packages of the project
   
```bash
$ flutter pub get
```

2.Then, select your flutter device. In vs code with "CTRL + SHIFT + P".

3. Hit run inside lib/main.dart file.

## Run DEV environment

```bash
$ docker compose -f docker-compose-dev.yml up -d
```

## Run QA environment

```bash
$ docker compose -f docker-compose-qa.yml up -d
```