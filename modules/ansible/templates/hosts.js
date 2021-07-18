[app]
%{ for app-host in app-instances ~}
${app-host}
%{ endfor ~}

[gitaly]
%{ for gitaly-host in gitaly-instances ~}
${gitaly-host}
%{ endfor ~}

[praefect]
%{ for praefect-host in praefect-instances ~}
${praefect-host}
%{ endfor ~}

[mon]
%{ for mon-host in mon-instances ~}
${mon-host}
%{ endfor ~}
