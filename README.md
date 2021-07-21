#GITALY:

## check io
  `#pidstat -dl 20`
##Configure replication factor
☝️ since Gitlab 13.12
- Gitaly Cluster supports electing repository-specific primary Gitaly nodes. Repository-specific
Gitaly primary nodes are enabled in /etc/gitlab/gitlab.rb by setting
  `praefect['failover_election_strategy'] = 'per_repository'`

- Setup for existing repo
  `sudo /opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml set-replication-factor -virtual-storage <virtual-storage> -repository <relative-path> -replication-factor <replication-factor>`
  -virtual-storage is the virtual storage the repository is located in.

  -repository is the repository's relative path in the storage.

  -replication-factor is the desired replication factor of the repository. The minimum value is 1, as the primary needs a copy of the repository. The maximum replication factor is the number of storages in the virtual storage.


##Determine primary Gitaly node
 curl localhost:9652/metrics | grep gitaly_praefect_primaries`

## Check connectivity gitaly nodes from praefect host
  `/opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml dial-nodes`
##Data loss

 - To check for repositories with outdated primaries, run:
    `sudo /opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml dataloss [-virtual-storage <virtual-storage>]`
 - Every configured virtual storage is checked if none is specified:
    `sudo /opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml dataloss`
 - Re-enable virtual storage for writes after data recovery attempts
    `sudo /opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml enable-writes -virtual-storage <virtual-storage>`
  OR
 - Accept data loss and re-enable writes for repositories after data recovery attempts have failed
     `/opt/gitlab/embedded/bin/praefect -config /var/opt/gitlab/praefect/config.toml accept-dataloss -virtual-storage <virtual-storage> -repository <relative-path> -authoritative-storage <storage-name>`

##Check replica checksum
 - gitlab:praefect:replicas prints out checksums of the repository of a given project_id on:
   The primary Gitaly node.
   Secondary internal Gitaly nodes.
   `sudo gitlab-rake "gitlab:praefect:replicas[project_id]"`

## Gracefully stop process
  `gitlab-ctl hup puma`
  - In case of restarting puma is required to restart sidekiq as well
    `gitlab-ctl restart sidekiq`

