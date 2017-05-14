#!/bin/bash

# Might not be reliable in future docker releases
# http://stackoverflow.com/questions/23513045/how-to-check-if-a-process-is-running-inside-docker-container
if [[ -f /.dockerenv ]];
then
    export IS_INSIDE_DOCKER=true
else
    export IS_INSIDE_DOCKER=false
    if [[ -f ./tools/resolve-env-outside-docker-hook.sh ]];
    then
      # You could e.g. add this to the custom-resolve-env file:
      # export DOCKER_IP=$(docker-machine ip default)
      echo "Executing ./tools/resolve-env-outside-docker-hook.sh .."
      source ./tools/resolve-env-outside-docker-hook.sh
    fi

    if [[ -z "$DOCKER_HOST" ]]
    then
        echo "Your environment does not define DOCKER_HOST variable, so"
        echo "we are assuming you are running native docker instead of docker-machine."
        echo -e "Setting DOCKER_IP=127.0.0.1 ..\n\n"
        export DOCKER_IP=127.0.0.1
    else
        if [[ -z "$DOCKER_IP" ]]
        then
            echo "Your environment does not either variable: DOCKER_HOST or DOCKER_IP, so"
            echo "you need to provide the IP address of machine running docker"
            echo "in the DOCKER_IP environment variable."
            echo -e "If you are running docker-machine, you could try uncommenting this line:"
            echo "# export DOCKER_IP=\$(docker-machine ip default)"
            echo -e "\nin tools/resolve-env.sh\n\n"
            return 1
        fi
    fi
fi

# For now using same postgres port in both environments
if [[ "$IS_INSIDE_DOCKER" = true ]]
then
  export DATABASE_HOST=mysql
  export DATABASE_PORT=3306
  export REDIS_HOST=redis
  export REDIS_PORT=6379
else
  export DATABASE_HOST=$DOCKER_IP
  export DATABASE_PORT=3306
  export REDIS_HOST=$DOCKER_IP
  export REDIS_PORT=9379
fi
