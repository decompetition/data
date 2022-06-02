#! /bin/bash

PORT=5432

usage() {
  echo "USAGE: $0 [-p <port>] datafile" 1>&2
  exit 1
}

while getopts "p:" opt; do
  case "$opt" in
    p)
      PORT="$OPTARG"
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ $# -ne 1 ]; then
  usage
fi

DATAFILE="$(basename "$1")"
DATAPATH="$(cd "$(dirname "$1")"; pwd)/$DATAFILE"
docker run --rm -it -p "$PORT:5432" -v "$DATAPATH:/docker-entrypoint-initdb.d/$DATAFILE:ro" postgres
