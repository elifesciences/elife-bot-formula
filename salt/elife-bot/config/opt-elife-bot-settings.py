"""
    Settings for eLife
    ~~~~~~~~~~~
    To specify multiple environments, each environment gets its own class,
    and calling get_settings will return the specified class that contains
    the settings.

    You must modify:
        aws_access_key_id
        aws_secret_access_key

"""


class dev():
    # AWS settings
    aws_access_key_id = ""
    aws_secret_access_key = ""

    workflow_context_path = 'workflow-context/'

    # SQS settings
    sqs_region = 'us-east-1'
    S3_monitor_queue = 'incoming-queue'
    event_monitor_queue = 'event-property-incoming-queue'
    workflow_starter_queue = 'workflow-starter-queue'
    website_ingest_queue = 'website-ingest-queue'
    workflow_starter_queue_pool_size = 5
    workflow_starter_queue_message_count = 5

    # S3 settings
    storage_provider = 's3'
    publishing_buckets_prefix = 'dev-'
    # shouldn't need this but uploads seem to fail without. Should correspond with the s3 region
    # hostname list here http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region

    s3_hostname = 's3.amazonaws.com'
    production_bucket = 'production'
    expanded_bucket = 'expanded'
    ppp_cdn_bucket = 'ppp-cdn'
    archive_bucket = 'archive'
    xml_bucket = 'xml'

    # lax endpoint to retrieve information about published versions of articles
    lax_article_versions = 'http://laxsite.example/api/v1/article/10.7554/eLife.{article_id}/version/'
    lax_update = 'http://laxsite.example/api/v1/import/article/'
    lax_update_user = ''
    lax_update_pass = ''
    verify_ssl = False

    no_download_extensions = 'tif'

    # end JR settings

    # S3 settings
    bucket = 'articles'
    prefix = 'dev'
    delimiter = '/'

    # SWF queue settings
    domain = "Publish.dev"
    default_task_list = "DefaultTaskList"

    # SimpleDB settings
    simpledb_region = "us-east-1"
    simpledb_domain_postfix = "_dev"

    # SES settings
    # email needs to be verified by AWS
    ses_region = "us-east-1"
    ses_sender_email = ""
    ses_admin_email = []

    # CDN bucket settings
    cdn_bucket = 'cdn'
    cdn_distribution_id = ''
    cdn_domain_name = '.cloudfront.net'

    # Lens bucket settings
    lens_bucket = 'lens'
    lens_distribution_id = ''
    lens_domain_name = '.cloudfront.net'

    # Lens jpg bucket
    lens_jpg_bucket = "lens-jpg"

    # Bot S3 settings
    bot_bucket = 'bot'

    # POA delivery bucket
    poa_bucket = 'poa'

    # POA packaging bucket
    poa_packaging_bucket = 'poa-packaging'

    # POA email settings
    ses_poa_sender_email = ""
    ses_poa_recipient_email = ""

    # PMC email settings
    ses_pmc_sender_email = ""
    ses_pmc_recipient_email = ""

    # EJP S3 settings
    ejp_bucket = 'ejp'

    # Crossref generation
    elifecrossref_config_file = 'crossref.cfg'
    elifecrossref_config_section = 'elife'

    # Crossref
    crossref_url = 'http://crossref.org/servlet/deposit'
    crossref_login_id = ''
    crossref_login_passwd = ''

    # PubMed generation
    elifepubmed_config_file = 'pubmed.cfg'
    elifepubmed_config_section = 'elife'

    # PoA generation
    jatsgenerator_config_file = 'jatsgenerator.cfg'
    jatsgenerator_config_section = 'elife'
    packagepoa_config_file = 'packagepoa.cfg'
    packagepoa_config_section = 'elife'

    # Decision letter parser
    letterparser_config_file = 'letterparser.cfg'
    letterparser_config_section = 'elife'

    # PubMed FTP settings
    PUBMED_FTP_URI = ""
    PUBMED_FTP_USERNAME = ""
    PUBMED_FTP_PASSWORD = ""
    PUBMED_FTP_CWD = ""

    # PMC FTP settings
    PMC_FTP_URI = ""
    PMC_FTP_USERNAME = ""
    PMC_FTP_PASSWORD = ""
    PMC_FTP_CWD = ""

    # HEFCE Archive FTP settings
    HEFCE_FTP_URI = ""
    HEFCE_FTP_USERNAME = ""
    HEFCE_FTP_PASSWORD = ""
    HEFCE_FTP_CWD = ""

    # HEFCE Archive SFTP settings
    HEFCE_SFTP_URI = ""
    HEFCE_SFTP_USERNAME = ""
    HEFCE_SFTP_PASSWORD = ""
    HEFCE_SFTP_CWD = ""

    # Cengage Archive FTP settings
    CENGAGE_FTP_URI = ""
    CENGAGE_FTP_USERNAME = ""
    CENGAGE_FTP_PASSWORD = ""
    CENGAGE_FTP_CWD = ""

    # GoOA FTP settings
    GOOA_FTP_URI = ""
    GOOA_FTP_USERNAME = ""
    GOOA_FTP_PASSWORD = ""
    GOOA_FTP_CWD = ""

    # Scopus FTP settings
    SCOPUS_FTP_URI = ""
    SCOPUS_FTP_USERNAME = ""
    SCOPUS_FTP_PASSWORD = ""
    SCOPUS_FTP_CWD = ""

    # Web of Science WoS FTP settings
    WOS_FTP_URI = ""
    WOS_FTP_USERNAME = ""
    WOS_FTP_PASSWORD = ""
    WOS_FTP_CWD = ""

    # Templates S3 settings
    templates_bucket = 'bot'

    # Logging
    setLevel = "INFO"
    
    # Session
    session_class = "RedisSession"

    # Redis
    redis_host = "127.0.0.1"
    redis_port = 6379
    redis_db = 0
    redis_expire_key = 86400

class prod(dev):
    pass

def get_settings(ENV = "dev"):
    """
    Return the settings class based on the environment type provided,
    by default use the dev environment settings
    """
    return eval(ENV)
