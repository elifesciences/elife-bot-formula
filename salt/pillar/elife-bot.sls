elife_bot:
    rmrf_enter:
        days: 7

elife:
    redis:
        persistent: true

    newrelic:
        enabled: False

    newrelic_python:
        application_folder: /opt/elife-bot
        service:
        dependency_state: elife-bot-virtualenv
