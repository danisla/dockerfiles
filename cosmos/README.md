# Cosmos Music Server

Docker stack that runs a private [ownCloud](https://owncloud.com/) and [Subsonic](http://www.subsonic.org/pages/index.jsp) instance.

## Setup

Private data and Nginx config are loaded via environment variables. Todo this, first copy your SSL certs and then run the provided scripts to base64 encode and save them to env files.

1. Copy your SSL certs to the conf/ssl directory as `server.crt` and `server.key`.
2. Run: `cd conf ; ./make_ssl_env` to encode the SSL cert and key and save it to an env file.
3. Edit the `conf/default.conf` file to match your domain.
4. Run: `./make_nginx_conf_env` to encode the conf and save it to an env file.

## Starting

Source private env file that exports `POSTGRES_PASSWORD` variable.

```sh
source ~/.owncloud_env_cosmos.bash ; docker-compose up -d
```

This will start the following containers:
- [postgres](https://hub.docker.com/_/postgres/)
- [owncloud](https://hub.docker.com/_/owncloud/)
- [subsonic](https://hub.docker.com/r/danisla/subsonic/)
- [nginx](https://hub.docker.com/_/nginx/)

Then edit the owncloud config.php file and add these lines to the config array. Replace `cosmos.danisla.com` with your domain name.

```php
'trusted_domains' =>
  array (
    0 => 'cosmos.danisla.com',
  ),
'overwrite.cli.url' => 'https://cosmos.danisla.com',
'overwritehost' => 'cosmos.danisla.com',
'overwritewebroot' => '/owncloud',
'overwriteprotocol' => 'https',
```

Subsonic may take a while to start, after it does you can change the music folder to any directory within the owncloud share, such as `/mnt/music/Music`
