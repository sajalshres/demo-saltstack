# Demo Salt Stack

Docker setup to spin up a salt master and two minions for development and testing environment

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

## Prerequisites

Docker Salt Stack requires the following:
*	Docker
*   Docker Compose

## Installation and Setup

### Install Docker CE
Installation is straight forward, but vaires by OS.

Detail instructions for each OS can be found [here](https://docs.docker.com/install/).

### Install Docker Compose
Installation is straight forward, but vaires by OS.

Detail instructions for each OS can be found [here](https://docs.docker.com/compose/install/).

### Clone the Docker Saltstack repository

Clone with **SSH**
```
git clone git@github.com:sajalshres/docker-saltstack.git
```

Clone with **HTTPS**
```
git clone https://github.com/sajalshres/docker-saltstack.git
```

## Start the Docker Saltstack
Open a terminal session and change directory to docker-saltstack repository and run:

```
docker-compose up -d
```

## Stop the Docker Saltstack
When you're finished, you can stop the containser with:

```
docker-compose stop
```

This command will stop the containser, but will preserver the data they've stored. If you want to completely wipe out the stored data, run:

```
docker-compose down
```

## Enter the bash of Salt Master:

```
docker-compose exec salt-master bash
```

## Execute Command from Master :

Accept all the keys of minions
```
salt-key -A
```

Ping all the minion machines
```
salt '*' test.ping
```



## Update Image:
To pull the latest image, run(With the containers stopped):

```
docker-compose pull
```

## Authors

* **Sajal Shrestha** - *Initial work*
