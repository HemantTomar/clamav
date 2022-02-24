#!/bin/bash
docker stop clamav
docker rm clamav
docker rmi clamav:1
