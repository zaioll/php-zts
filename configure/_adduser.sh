#!/bin/bash

useradd -U -u 1000 --create-home --home-dir $HOME ${usuario} -s /bin/bash -G www-data
