elife_bot:
    rmrf_enter:
        days: 7

elife:
    # for testing
    ftp_users:
        pubmed:
            username: pubmed
            password: $1$TftAynzZ$oJ09ic/KNgkD1FCEfhZyz1 # pubmed
    redis:
        persistent: true

    newrelic:
        enabled: False

    newrelic_python:
        application_folder: /opt/elife-bot
        service:
        dependency_state: elife-bot-virtualenv
