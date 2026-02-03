FROM freshrss/freshrss:latest

# Modify Apache configuration to serve as default virtual host
RUN cat > /etc/apache2/sites-available/FreshRSS.Apache.conf <<'EOF'
<VirtualHost _default_:80>
    DocumentRoot /var/www/FreshRSS/p

    <Directory /var/www/FreshRSS/p>
        AllowOverride All
        Require all granted
    </Directory>

    # Public Web root. Only the content of this folder should be exposed if possible (`p/` should not be visible in the public URL)
    <Directory "/var/www/FreshRSS">
        DirectoryIndex index.php
        # The following options are already set by default in Apache 2.4, but they are explicit here for clarity
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # API
    <Directory "/var/www/FreshRSS/p/api">
        AllowOverride None
        Require all granted
    </Directory>

    # Extensions
    <Directory "/var/www/FreshRSS/extensions">
        DirectoryIndex index.php
        AllowOverride All
        Require all granted
    </Directory>

    # Logs (no access)
    <Directory "/var/www/FreshRSS/data/logs">
        Require all denied
    </Directory>

    # Better security (when not using external authentication)
    <Directory "/var/www/FreshRSS/p/i">
        Require all granted
    </Directory>

    # Prevent access to documentation unless authenticated
    <Directory "/var/www/FreshRSS/docs">
        Require all granted
    </Directory>

    # Prevent access to tests unless authenticated
    <Directory "/var/www/FreshRSS/tests">
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
EOF