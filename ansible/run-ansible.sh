#!/bin/bash

# run ansible.yml found in the current directory
ANSIBLE_CONFIG=${BASEDIR}/ansible/ansible.cfg ansible-playbook -e ansible_become_password=${PW} ansible.yml
