elife_bot:
    rmrf_enter:
        days: 7

    loris:
        resolver:
            #impl = 'loris.resolver.SimpleFSResolver'
            #src_img_root: /usr/local/share/images

            impl: loris.resolver.SimpleHTTPResolver
            source_prefix: https://publishing-cdn.elifesciences.org/
            cache_root: /usr/local/share/images/loris
            #source_suffix='/datastreams/accessMaster/content'
            #user='<if needed else remove this line>'
            #pw='<if needed else remove this line>'
            #cert='<SSL client cert for authentication>'
            #key='<SSL client key for authentication>'
            #ssl_check='<Check for SSL errors. Defaults to True. Set to False to ignore issues with self signed certificates>'
