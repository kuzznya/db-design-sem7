#!/bin/bash

PGPASSWORD=password psql --dbname=postgres --username=postgres --host=localhost -v ON_ERROR_STOP=1 "$@"
