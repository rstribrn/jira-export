************************
Static JIRA issue export
************************

Export all issues of a JIRA issue tracker instance into static
HTML files.

This static files can be indexed by an intranet search engine
easily, without having to setup autologin in JIRA.

The first export will take quite some time.
After that initial run, only projects with modifications since the last
export will get updated, which makes it possible to run the export
as cronjob every 15 minutes.

Note: If you use jira 4.4, only export once a day.
``jira-export`` doesn't support partial updates with it.

=============
Setup classic
=============

#. Switch to the folder you want to set this all up in, e.g. ``/home/myuser/``
#. Clone git repository, e.g. ``git clone https://github.com/netresearch/jira-export.git``
#. ``$ cp ./data/config.php.dist ./data/config.php``
#. Set up/edit ``./data/config.php``
#. Install composer (if you don't have it already).. https://getcomposer.org/
    #. Run composer setup ``php composer-setup.php``
    #. Check composer is working (esp behind a proxy) using ``php composer.phar diag``
    #. If you have proxy problems, set up HTTP_PROXY, HTTPS_PROXY env variables
#. Install dependencies
    #. Run ``php composer.phar install``
#. (Optional) Add proxy support to ``export-html.php``. Go to line 191 and add..
    ``'proxy_host'        => 'myproxy', 'proxy_port'        => 8080``
#. Run the initial import: ``php ./bin/export-html.php``
#. Setup the web server document root to ``www/``
#. Setup cron to run the export every 15 minutes.


=================
Setup with docker
=================

#. Clone git repository
#. ``$ cp data/config.php.dist ./data/config.php``
#. Adjust ``data/config.php``
#. Adjust docker-compose.override.yml to your needs
#. Run: docker-compose run build build
#. Run: docker-compose up -d
#. Alternatively with --network=host: docker-compose -f docker-compose.yml -f docker-compose.hostnet.yml up -d
#. Setup cron to run the export every 15 minutes.

Note: Rename docker-compose.hostnet.yml to docker-compose.override.yml in order to use network=host for build/app containers

=================
Access exported files
=================

Files are placed in Docker volume "html", see:

docker volume inspect jira-export_html

========================
Additional configuration
========================

Export some projects only
=========================
If you care about only a fraction of the projects in a JIRA instance,
you can choose to export those only.

Simply adjust ``$allowedProjectKeys`` in your configuration file::

    $allowedProjectKeys = array('FOO', 'BAR');


Multiple JIRA instances
=======================
Use the ``-c`` command line option:

   $ ./bin/export-html.php -c data/config-another.customer.php


===============
Troubleshooting
===============

User sees fewer issues than expected
=====================================
If the export shows fewer issues than JIRA UI reports (e.g., 6183 instead of 15622),
the configured user likely has **limited permissions**.

JIRA REST API only returns issues the authenticated user can see. To verify:

#. Open in browser: ``https://your-jira.com/rest/api/latest/search?jql=project%3D%22PROJECT%22&maxResults=0``
#. Check the ``total`` field in JSON response
#. Compare with what the script reports

**Solution:**

* Use an administrator account with full project access, or
* Grant the configured user "Browse Projects" and "View Issues" permissions for all relevant projects

Note: Different users may see different issue counts based on their JIRA permissions,
security levels, and workflow restrictions.


============
Dependencies
============

* PHP
* Atlassian JIRA, at least version 4.4 with activated REST API.
  Version 5.1 or higher recommended.
* ``Console_CommandLine`` from PEAR
* ``HTTP_Request2`` from PEAR

=============
Similar tools
=============

* `Gigan`__ - Parse JIRA XML into CouchDB

__ https://github.com/janl/gigan

=================
Uninstallation
=================

#. Run: docker-compose down
#. Run: docker rmi netresearch/jira-export:latest
#. Run: docker rmi jira-export_build:latest
#. Run: docker rmi nginx:alpine
#. Run: docker rmi php:7.4-cli-alpine
#. Run: docker rmi php:8-alpine

Cleanup including unused containers/volumes:
#. Run: docker ps --all
#. Run: docker container prune
#. Run: docker volume ls
#. Run: docker volume prune

Explicit volume cleanup:
#. Run: docker volume rm jira-export_html

=================
About jira-export
=================

License
=======
``jira-export`` is licensed under the `AGPL v3`__ or later.

__ http://www.gnu.org/licenses/agpl


Author
======
`Christian Weiske`__, `Netresearch GmbH & Co KG`__

__ mailto:christian.weiske@netresearch.de
__ http://www.netresearch.de/
