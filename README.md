# devops-final-project: Customer Accounts REST Microservice

[![CI](https://github.com/Shravanis30/devops-final-project/actions/workflows/workflow.yml/badge.svg)](https://github.com/Shravanis30/devops-final-project/actions/workflows/workflow.yml)

## Project Overview

This repository contains the **Customer Accounts REST Microservice** and its automated CI/CD pipeline, developed for the Coursera DevOps Final Project ("Final Project: Submission and Evaluation").

The application provides a RESTful API for managing customer account entities stored in a PostgreSQL database. It is built using Python and Flask, follows cloud-native best practices (Twelve-Factor App methodology), incorporates containerization with Docker, and features end-to-end continuous integration and delivery with GitHub Actions and Tekton / Red Hat OpenShift Pipelines.

---

## Architecture and Directory Structure

```text
├── .github/
│   └── workflows/
│       └── workflow.yml        <- GitHub Actions CI workflow (Flake8 lint & nosetests)
├── .tekton/
│   └── tasks.yml               <- Tekton CI/CD tasks (cleanup, nose unit testing)
├── tekton/
│   ├── pipeline.yaml           <- OpenShift / Tekton CD Pipeline definition
│   ├── pvc.yaml                <- OpenShift PersistentVolumeClaim manifest
│   └── tasks.yaml              <- OpenShift Tekton tasks
├── deploy/
│   ├── deployment.yaml         <- Kubernetes / OpenShift Deployment manifest
│   ├── service.yaml            <- Kubernetes Service manifest
│   └── route.yaml              <- OpenShift Route manifest
├── service/                    <- Microservice application package
│   ├── common/                 <- Error handlers, logging, and CLI commands
│   ├── config.py               <- Database & application configuration
│   ├── models.py               <- SQLAlchemy Account model
│   ├── routes.py               <- Flask REST API route handlers
│   └── __init__.py             <- Application factory, Talisman security, and CORS
├── tests/                      <- Unit test suite (>= 95% test coverage)
│   ├── factories.py            <- Factory Boy account generators
│   ├── test_cli_commands.py    <- Tests for Flask DB administration commands
│   ├── test_models.py          <- Unit tests for Account model CRUD
│   └── test_routes.py          <- Unit tests for REST endpoints and security
├── Dockerfile                  <- Production Docker container definition
├── requirements.txt            <- Python dependencies
└── setup.cfg                   <- Configuration for nosetests, flake8, and coverage
```

---

## Application Functionality & REST API Endpoints

The service manages `Account` records containing:
- `id`: Unique integer identifier (Primary Key)
- `name`: Customer name (String, required)
- `email`: Customer email (String, required)
- `address`: Physical mailing address (String, required)
- `phone_number`: Contact phone number (String, optional)
- `date_joined`: Registration date (Date, required)

### Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/` | Service root status and paths index |
| `GET` | `/health` | Liveness / readiness health check endpoint |
| `POST` | `/accounts` | Create a new customer account |
| `GET` | `/accounts` | List all customer accounts |
| `GET` | `/accounts/<id>` | Read an account by ID |
| `PUT` | `/accounts/<id>` | Update an existing customer account |
| `DELETE` | `/accounts/<id>` | Delete an account by ID |

---

## Continuous Integration & Continuous Delivery (CI/CD)

1. **GitHub Actions Workflow (`.github/workflows/workflow.yml`)**:
   - Triggers on every push and pull request to `main`.
   - Spins up a PostgreSQL service container for integration tests.
   - Sets up Python 3.9 runtime and installs dependencies.
   - Executes code style checks and linting with **flake8**.
   - Runs the test suite using **nosetests** with full coverage reporting.

2. **Tekton & OpenShift Pipelines (`.tekton/tasks.yml` & `tekton/pipeline.yaml`)**:
   - Automated cloud-native pipeline running on Red Hat OpenShift.
   - Cleans workspace volume using the **cleanup** task.
   - Clones repository using Tekton `git-clone`.
   - Executes linting via **flake8**.
   - Runs unit test suite via **nose**.
   - Builds container image using `buildah`.
   - Deploys the microservice manifests to the OpenShift cluster.
