#!/bin/sh

docker run -it \
-p 3000:3000 \
-v "$PWD/src":/var/www/html:Z \
--name $1 $2 \
/bin/bash
