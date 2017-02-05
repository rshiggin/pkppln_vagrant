## Introduction

A virtual machine for testing the [Open Journal Systems](http://pkp.sfu.ca/ojs/) 3.x PKP PLN plugin. It should work on any operating system that supports VirtualBox and Vagrant.

This virtual machine **should not** be used in production.

## Prerequisites

Install the following prerequisites on your laptop or desktop:

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](http://www.vagrantup.com/)

## Setting up your virtual machine

1. `git clone https://github.com/mjordan/pkppln_vagrant
2. `cd pkppln_vagrant`
3. `vagrant up`

When all the scripts have finished running, your virtual machine is ready for use.

## Accessing OJS

Point your browser at http://localhost:8000/ojs
* The administrator account has username: ojs password: ojs

## Accessing the PKP PLN staging server application

Point your browser at http://localhost:8000/pkppln/web/app.php
* The administrator account has username: admin@example.com password: admin

## Other details you might find useful

You can connect to the machine via ssh: `ssh -p 2222 vagrant@localhost` and log in with:
  - username: vagrant
  - password: vagrant

You won't normally need the following but just in case:

MySQL credentials:
  - username: root
  - password: ojs

OJS database details:
  - database: ojs
  - user: ojs
  - password: ojs

## Thanks

This Vagrant virtual machine is inspired by the [Islandora Vagrant](https://github.com/Islandora-Labs/islandora_vagrant).
