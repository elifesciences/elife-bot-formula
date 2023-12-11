elife_bot:
    temporary_files_cleaner:
        days: 7
    iiif:
        url: https://iiif.example.org/
    medium:
        application_client_id: 1234s5b67am890p31l722ee3fe1fd874f171953214406731afddb1754e67655cd
        application_client_secret: a1234567b8cd
        access_token: a9b4587c723de18fghi1jk56lmno5pq18rst5uv9
    gcp:
        credentials_json: '{}'
    profiling:
        env_list:
            - dev
            - continuumtest
        processes:
            worker:
                args: ""

elife:

    external_volume:
        directory: /bot-tmp

    # for testing
    ftp_users:
        pubmed:
            username: pubmed
            password: $1$TftAynzZ$oJ09ic/KNgkD1FCEfhZyz1 # pubmed
    redis:
        persistent: true

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

    multiservice:
        services:
            worker:
                service_template: elife-bot-worker-service
                num_processes: 1
            
