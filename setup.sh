#!/bin/bash

set -o allexport && source .env && set +o allexport && terraform init && terraform apply
