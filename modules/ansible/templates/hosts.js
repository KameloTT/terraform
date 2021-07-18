[app]
%{ for app-host in app_instances ~}
${app-host}
%{ endfor ~}

[gitaly]
%{ for gitaly-host in gitaly_instances ~}
${gitaly-host}
%{ endfor ~}

[praefect]
%{ for praefect-host in praefect_instances ~}
${praefect-host}
%{ endfor ~}

[mon]
%{ for mon-host in mon_instances ~}
${mon-host}
%{ endfor ~}
