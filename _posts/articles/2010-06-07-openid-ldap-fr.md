---
title: OpenID et LDAP
layout: default
categories: [fr, articles]
---

## Description

[OpenID-LDAP](http://www.openid-ldap.org/) consiste en une s&eacute;rie de
scripts PHP permettant d'associer une identit&eacute; OpenID &agrave; une
entr&eacute;e LDAP. Les fonctionnalit&eacute;s de ce dernier sont
relativement r&eacute;duites, ce qui permet de l'&eacute;tendre facilement
en fonction de ses besoins. Une option int&eacute;ressante est la
possibilit&eacute; de mapper des donn&eacute;es en provenance du LDAP avec
des attributs OpenID. En couplant OpenID-LDAP au module d'apache OpenID,
on peut facilement faire &eacute;voluer un syst&egrave;me utilisant
mod_authz_ldap sur une solution SSO.

## Installation & configuration

### Configuration du virtualhost

Dans un premier temps, il faut r&eacute;cup&eacute;rer OpenID-LDAP et
configurer le VirtualHost associ&eacute;.

{% highlight bash %}
$ cd /var/www/
$ wget http://www.openid-ldap.org/releases/openid-ldap-0.8.7-noarc.tar.gz
$ tar -xf openid-ldap-0.8.7-noarc.tar.gz
$ mv openid-ldap-0.8.7 openid
{% endhighlight %}

Nous partitons du principe que le provider est install&eacute; sur
le domaine __openid.domain.org__. OpenID-LDAP n&eacute;cessite une
connection s&eacute;curis&eacute;e via HTTPS, nous allons donc lui
d&eacute;dier un VirtualHost sur le port 443. De plus, certaines
r&egrave;gles d'URL rewriting sont n&eacute;cessaires afin de
rediriger correctement les requ&ecirc;tes sur les bons scripts.

{% highlight apache %}
<VirtualHost *:443>
    SSLProxyEngine on
    DocumentRoot "/var/www/openid"
    ServerName openid.domain.org
    ErrorLog /var/log/apache2/error.log
    LogLevel warn
    CustomLog /var/log/apache2/access.log combined
    SSLEngine on
    SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
    SSLCertificateFile "/etc/apache2/server.crt"
    SSLCertificateKeyFile "/etc/apache2/server.key"
    <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>

    # Specific stuff for OpenID-LDAP                                                                                                                                             
    RewriteEngine On
    RewriteCond %{REQUEST_URI} !^/(.+)\.php(.*)$
    RewriteCond %{THE_REQUEST} ^[A-Z]{3,9}\ /([A-Za-z0-9]+)\?(.*)\ HTTP/
    RewriteRule ^/(.*)$ /index.php?user=%1&%2 [P]
    RewriteCond %{REQUEST_URI} !^/(.+)\.php(.*)$
    RewriteRule ^/([A-Za-z0-9]+)$ /index.php?user=$1 [P]
</VirtualHost>
{% endhighlight %}

### Configuration d'OpenID-LDAP

On doit maintenant configurer OpenID-LDAP afin qu'il soit capable
de dialoguer avec notre serveur LDAP. On doit pour cela &eacute;diter
le fichier __/var/www/openid/ldap.php__, et y renseigner les
informations sur le serveur LDAP, notamment la mani&egrave;re dont
seront associ&eacute; comptes LDAP et comptes OpenID.

{% highlight php %}
$GLOBALS['ldap'] = array (
        // IP primaire du serveur LDAP
        'primary'               => '10.0.0.111',
        // IP secondaire du serveir LDAP
        'fallback'              => '10.0.0.222',
        // Version du protocole LDAP a utiliser
        'protocol'              => 3,
 
        // Activer ou non Active Directory
        'isad'                  => false,
        // Extraire ou non le CV apres la recherche
        'lookupcn'              => false,
 
        // DN du compte administrateur
        'binddn'                => 'cn=root,cn=users,dc=domain,dc=org', // dn du compte administrateur
        // Mot de passe du compte administrateur
        'password'              => 'XXX',
 
        // Recherche a effectuer pour valider le pass d'un utilisateur
        // %s sera remplace par l'identite demandee
        'testdn'                => 'cn=%s,ou=People,dc=domain,dc=org',
 
        // DN dans lequel se trouvent les utilisateurs
        'searchdn'              => 'ou=People,dc=domain,dc=org',
        // Filtre associe au SearchDN
        'filter'                => '(uid=%s)',
 
        // Mapping entre donnees OpenID et champs LDAP
        'nickname'              => 'uid',
        'email'                 => 'mail',
        'fullname'              => array('givenname', 'sn'),
        'country'               => 'c'
);
{% endhighlight %}

### Utilisation

L'utilisateur peut &agrave; pr&eacute;sent s'authentifier sur la page
__https://openid.domain.org/username__, et utiliser cette derni&egrave;re pour
acc&eacute;der aux diff&eacute;rents services &agrave; sa disposition.
