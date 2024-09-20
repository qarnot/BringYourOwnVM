# Retex Packer

Réussi pour l'instant avec Packer :
- build des conteneurs Docker
- build des images disk qcow2 Debian en partant d'une ISO et en ajoutant des 
scripts de provisionnement et du post-process

Pas totalement réussi pour l'instant :
- faire un template "assez générique" qui build des images Windows/Windows 
Server.
- 

## Points forts

- est capable de gérer toutes les actions du téléchargement de l'ISO à la 
config de la VM, l'installation de l'OS via l'installer, le provisionnement de
la VM et le pot-process (compression, export etc.)

- les fichiers de config Packer peuvent être écrits en JSON (pas besoin
d'apprendre un nouveau langage)

- point faible ou fort ça dépend, le language HCL semble avoir plus de 
fonctionnalités que du JSON vanilla, notamment au niveau de la gestion des
variables. A vérifier si c'est réellement le cas.

## Points faibles

- les de configurations automatiques pour les installers ne sont pas très 
génériques : Debian utilise des "preseed", Windows un "unattend.xml", CentOS un 
fichier de config ".cfg" utilisant encore une syntaxe différente.

- projet mal documenté : documentation mauvaise voire absente pour la plupart 
des plugins, plugins pourtant indispensables pour utiliser Packer.

## TODO
...
