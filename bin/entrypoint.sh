#!/bin/sh

set -e

APP_GUNICORN_USE=${APP_GUNICORN_USE:-"starnavi_test_task.app.wsgi:application"}
APP_GUNICORN_MAX_REQUESTS=${APP_GUNICORN_MAX_REQUESTS:-"1000"}

APP_WORKERS_DEFAULT=$(nproc)
APP_WORKERS=${APP_WORKERS:-$APP_WORKERS_DEFAULT}

APP_HOST=${APP_HOST:-"0.0.0.0"}
APP_PORT=${APP_PORT:-"8000"}

if ! [ -z "$APP_MIGRATE" ]; then
  python manage.py migrate
fi

if ! [ -z "$DEBUG" ]; then
  python manage.py runserver ${APP_HOST}:${APP_PORT}
else
  gunicorn -b ${APP_HOST}:${APP_PORT} --capture-output --reload --max-requests $APP_GUNICORN_MAX_REQUESTS -w $APP_WORKERS -k gevent $APP_GUNICORN_USE
fi