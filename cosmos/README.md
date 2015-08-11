# Cosmos Music Server

Docker stack that runs a private [ownCloud](https://owncloud.com/) and [Subsonic](http://www.subsonic.org/pages/index.jsp) instance.

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
