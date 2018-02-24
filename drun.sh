#!/bin/sh

docker run -it \
-p 3000:3000 \
-v "$PWD/Soco":/var/www/html:Z \
--name $2 $3 \
/bin/bash
