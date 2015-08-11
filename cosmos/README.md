# Cosmos Music Sync

## Starting

```sh
source ~/.owncloud_env_cosmos.bash ; docker-compose up -d
```

Then edit the owncloud config.php file and add these lines to the config array

```
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
