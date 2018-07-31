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

    sidecars:
        containers:
            mailcatcher:
                image: elifesciences/mailcatcher
                tag: 20180717
                name: mailcatcher
                ports:
                    # SMTP
                    - "1025:1025"
                    # HTTP API to check captured emails
                    - "1080:1080"
                enabled: true
