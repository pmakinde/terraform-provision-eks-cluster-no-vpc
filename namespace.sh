#!/bin/bash

# update kubeconfig
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
kubectl create namespace dwp-cv-dev
