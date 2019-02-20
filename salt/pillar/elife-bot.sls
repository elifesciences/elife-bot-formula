elife_bot:
    rmrf_enter:
        days: 7
    iiif:
        url: https://iiif.example.org/
    medium:
        application_client_id: 1234s5b67am890p31l722ee3fe1fd874f171953214406731afddb1754e67655cd
        application_client_secret: a1234567b8cd
        access_token: a9b4587c723de18fghi1jk56lmno5pq18rst5uv9
    journal:
        url = 'https://elifesciences.org'

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

    mockserver:
        expectations:
            elife_bot: salt://elife-bot/config/mockserver-elife-bot.sh
