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
    event_monitor_topic = 'arn:aws:sns:eu-west-1:123456789012:elife-bot-event-property--dev'
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
    digest_cdn_bucket = 'digests'
    archive_bucket = 'archive'

    lax_article_endpoint = "http://gateway.internal/articles/{article_id}"
    # lax endpoint to retrieve information about published versions of articles
    lax_article_versions = 'http://gateway.internal/articles/{article_id}/versions'
    lax_article_versions_accept_header = "application/vnd.elife.article-history+json;version=2"
    lax_article_related = "http://gateway.internal/articles/{article_id}/related"
    verify_ssl = False
    lax_auth_key = ''

    no_download_extensions = 'tif'

    # end JR settings

    # SWF queue settings
    domain = "Publish.dev"
    default_task_list = "DefaultTaskList"

    # SES settings
    # email needs to be verified by AWS
    ses_region = "us-east-1"
    ses_sender_email = ""
    ses_admin_email = []
    ses_bcc_recipient_email = ""

    # SMTP settings
    smtp_host = 'localhost'
    smtp_port = 2525
    smtp_starttls = False
    smtp_ssl = False
    smtp_username = None
    smtp_password = None

    # Lens bucket settings
    lens_bucket = 'lens'

    # Lens jpg bucket
    lens_jpg_bucket = "lens-jpg"

    # Bot S3 settings
    bot_bucket = 'bot'

    # POA delivery bucket
    poa_bucket = 'poa'

    # POA packaging bucket
    poa_packaging_bucket = 'poa-packaging'

    # Article subjects data
    article_subjects_data_bucket = "bot/article_subjects_data"
    article_subjects_data_file = "article_subjects.csv"

    # POA email settings
    ses_poa_sender_email = ""
    ses_poa_recipient_email = ""

    # Digest email settings
    digest_config_file = 'digest.cfg'
    digest_config_section = 'elife'
    digest_sender_email = ""
    # recipients of digest validation error emails
    digest_validate_error_recipient_email = []
    # recipients of digest docx email attachment
    digest_docx_recipient_email = []
    # recipients of post digest to endpoint emails and error emails
    digest_jats_recipient_email = []
    digest_jats_error_recipient_email = []
    # recipients of digest medium post created emails
    digest_medium_recipient_email = []

    # digest endpoint
    digest_endpoint = 'https://example.org/digests/{digest_id}'
    digest_auth_key = ""

    # digest typesetter endpoint
    typesetter_digest_endpoint = 'https://example.org/job.api/updateDigest'
    typesetter_digest_api_key = ''
    typesetter_digest_account_key = '1'

    # decision letter
    decision_letter_sender_email = 'sender@example.org'
    decision_letter_validate_error_recipient_email = 'error@example.org'
    decision_letter_output_bucket = 'dev-elife-bot-decision-letter-output'
    decision_letter_bucket_folder_name_pattern = 'elife{manuscript:0>5}'
    decision_letter_xml_file_name_pattern = 'elife-{manuscript:0>5}.xml'
    typesetter_decision_letter_endpoint = 'https://typesetter/updatedigest'
    typesetter_decision_letter_api_key = 'typesetter_api_key'
    typesetter_decision_letter_account_key = '1'
    decision_letter_jats_recipient_email = ["e@example.org", "life@example.org"]
    decision_letter_jats_error_recipient_email = "error@example.org"

    # PMC or FTP sending error email settings
    ftp_deposit_error_sender_email = "sender@example.org"
    ftp_deposit_error_recipient_email = ["e@example.org", "life@example.org"]

    # journal preview
    journal_preview_base_url = 'https://preview.example.org'

    # Publication email settings
    features_publication_recipient_email = []

    # Email video article published settings
    email_video_recipient_email = []

    # EJP S3 settings
    ejp_bucket = 'ejp'

    # Templates settings
    email_templates_path = "/opt/elife-email-templates"

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

    # PubMed SFTP settings
    PUBMED_SFTP_URI = ""
    PUBMED_SFTP_USERNAME = ""
    PUBMED_SFTP_PASSWORD = ""
    PUBMED_SFTP_CWD = ""

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
    HEFCE_EMAIL = ""

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

    # Web of Science WoS FTP settings
    WOS_FTP_URI = ""
    WOS_FTP_USERNAME = ""
    WOS_FTP_PASSWORD = ""
    WOS_FTP_CWD = ""
    WOS_EMAIL = ""

    # CNPIEC FTP settings
    CNPIEC_FTP_URI = ""
    CNPIEC_FTP_USERNAME = ""
    CNPIEC_FTP_PASSWORD = ""
    CNPIEC_FTP_CWD = ""

    # CNKI FTP settings
    CNKI_FTP_URI = ""
    CNKI_FTP_USERNAME = ""
    CNKI_FTP_PASSWORD = ""
    CNKI_FTP_CWD = ""
    CNKI_EMAIL = ""

    # CLOCKSS FTP settings
    CLOCKSS_FTP_URI = ""
    CLOCKSS_FTP_USERNAME = ""
    CLOCKSS_FTP_PASSWORD = ""
    CLOCKSS_FTP_CWD = ""

    # OVID FTP settings
    OVID_FTP_URI = ""
    OVID_FTP_USERNAME = ""
    OVID_FTP_PASSWORD = ""
    OVID_FTP_CWD = ""

    # Zendy SFTP settings
    ZENDY_SFTP_URI = ""
    ZENDY_SFTP_USERNAME = ""
    ZENDY_SFTP_PASSWORD = ""
    ZENDY_SFTP_CWD = ""
    ZENDY_EMAIL = ""

    # Logging
    setLevel = "INFO"
    
    # Session
    session_class = "S3Session"
    s3_session_bucket = "prod-sessions"

    # Redis
    redis_host = "127.0.0.1"
    redis_port = 6379
    redis_db = 0
    redis_expire_key = 86400

    github_token = ""
    git_repo_name = "article-xml"
    git_repo_path = "articles/"

    # eLife 2.0 bot lax communication settings
    xml_info_queue = "inc"
    lax_response_queue = "out" 
    video_url = "https://video-metadata.example.org/"

    pdf_cover_generator = "http://personalised-covers.example.org/personalised-covers/"
    # temporary
    pdf_cover_landing_page = "http://personalised-covers.example.org/personalcover/options"

    # IIIF
    path_to_iiif_server = "https://iiif.example.org/lax/"
    iiif_resolver = "{article_id}%2F{article_fig}/full/full/0/default.jpg"

    # Fastly CDNs
    fastly_service_ids = ['', '']
    fastly_api_key = ''

    article_path_pattern = "/articles/{id}v{version}"

    # BigQuery settings
    big_query_project_id = "data-pipeline"

    # DOAJ deposit settings
    journal_eissn = ""
    doaj_url_link_pattern = "https://example.org/articles/{article_id}"
    doaj_endpoint = "https://doaj/api/v2/articles"
    doaj_api_key = ""

    # Software Heritage deposit settings
    software_heritage_deposit_endpoint = "https://deposit.swh.example.org/1"
    software_heritage_collection_name = "elife"
    software_heritage_auth_user = "user"
    software_heritage_auth_pass = "pass"
    software_heritage_api_get_origin_pattern = "https://archive.swh.example.org/api/1/origin/{origin}/get/"

    # ERA article incoming queue
    era_incoming_queue = "dev-era-incoming-queue"

    # Accepted submission workflow
    accepted_submission_sender_email = "sender@example.org"
    accepted_submission_validate_error_recipient_email = ["e@example.org", "life@example.org"]
    accepted_submission_queue = ""


class prod(dev):
    pass

def get_settings(ENV = "dev"):
    """
    Return the settings class based on the environment type provided,
    by default use the dev environment settings
    """
    return eval(ENV)
