#!/bin/sh

SERVICE_NAMES=( "bh-admin" "bh-api" "bh-core" "bh-drive" "bh-notifications" "bh-explore" "bh-worker" "bh-people")
BASE_COMPOSE_FILE="docker-compose-plt.yml"

USAGE="Usage: $(basename "$0") [options] <command> [arguments]

Options:
    --debug - use debug configs for any command and all services
    --debug-part - use debug configs for any command and specified services (dependent services will be loaded with normal config)

Commands:
    build [SERVICE_NAME(S)] - build dockers for selected services (all services by default)
    up [SERVICE_NAME(S)] - run all selected services and its dependencies (all services by default)
    logs [SERVICE_NAME(S)] - print logs for all bh-services
    ps - show statistic of running services

Examples:
    $(basename "$0") build                       - build dockers for all services
    $(basename "$0") --debug up bh-admin         - run bh-admin and all dependencies in debug mode
    $(basename "$0") --debug-part up bh-admin    - run only bh-admin in debug mode and all dependencies
    $(basename "$0") logs                        - print logs for all bh-services
    $(basename "$0") logs bh-admin               - print bh-admin logs
    $(basename "$0") ps                          - show statistic of running services
"

combine_debug_args () {
  for i in "$@"; do printf " -f compose-dev/$i.compose.yml"; done
}

if [ "$#" == "0" ]; then
    echo "$USAGE"
    exit 1;
fi

if [ "$1" == "--debug" ]; then
    shift
    DEBUG=true
fi

if [ "$1" == "--debug-part" ]; then
    shift
    DEBUG_PART=true
fi

case $1 in
  build)
    shift

    if [ "$DEBUG" ]; then
      SERVICES=( ${SERVICE_NAMES[@]} )
    fi

    echo "Build services..."
    docker-compose -f $BASE_COMPOSE_FILE $(combine_debug_args "${SERVICES[@]}") build "$@"
    ;;

  up)
    shift
    if [ "$DEBUG_PART" ]; then
      if [ "$#" == "0" ]; then
        VALUE=$(combine_debug_args "${SERVICE_NAMES[@]}")
      else
        VALUE=$(combine_debug_args "$@")
      fi
    elif [ "$DEBUG" ] ; then
      VALUE=$(combine_debug_args "${SERVICE_NAMES[@]}")
    fi

    echo "docker-compose -f $BASE_COMPOSE_FILE$VALUE up -d $@"
    docker-compose -f $BASE_COMPOSE_FILE$VALUE up -d $@
    ;;

  logs)
    shift
    if [ "$#" == "0" ]; then
      SERVICES=( ${SERVICE_NAMES[@]} )
    else
      SERVICES="$@"
    fi
    docker-compose -f $BASE_COMPOSE_FILE logs --tail=100 -f "${SERVICES[@]}"
    ;;

  *)
    echo "docker-compose "$@""
    docker-compose "$@"
esac
