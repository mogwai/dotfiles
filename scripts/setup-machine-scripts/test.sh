#!/bin/bash

# A script to test the generated script on a box to make sure that it works
# (Requires Docker)

docker run -ti -v $(pwd):/app ubuntu bash -c "bash /app/install.sh && bash"
