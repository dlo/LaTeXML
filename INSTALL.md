Copied from [here](https://web.archive.org/web/20170421212858/https://www.formulasearchengine.com/LaTeXML)

This is a short guide how to install the non graphical version of LaTeXML on debian as a web service that you can use as server for converting LaTeX to MathML. If you need a user interface see this outdated [guide](https://web.archive.org/web/20170331191031/http://formulasearchengine.com/LaTeXML_UI). here a part of my history where I insalled everything from my LaTeXML home '/home/LaTeXML' replace that with whatever you think suitable for you.

```sh
sudo apt-get install   \
        libarchive-zip-perl libfile-which-perl libimage-size-perl \
        libio-string-perl libjson-xs-perl libwww-perl libparse-recdescent-perl \
        liburi-perl libxml2 libxml-libxml-perl libxslt1.1 libxml-libxslt-perl \
        texlive imagemagick perlmagick make
mkdir /home/LaTeXML
cd /home/LaTeXML
git clone https://github.com/brucemiller/LaTeXML.git
cd LaTeXML/
perl Makefile.PL
make
sudo make install
cd /home/LaTeXML
sudo apt-get install libplack-perl libapache2-mod-perl2 apache2
git clone https://github.com/dginev/LaTeXML-Plugin-ltxpsgi.git
cd LaTeXML-Plugin-ltxpsgi
perl Makefile.PL
make
sudo make install
cd /etc/apache2/sites-available/
vi latexml.conf
```

and paste the contents of my latexml config file which I have given below:

```apache
Listen 8888

<VirtualHost *:8888>
    ServerName localhost
    PerlOptions +Parent

    <Perl>
      $ENV{PLACK_ENV} = 'production';
    </Perl>

    <Location />
      SetHandler perl-script
      PerlHandler Plack::Handler::Apache2
      PerlSetVar psgi_app /usr/local/bin/ltxpsgi
    </Location>

    ErrorLog /var/log/apache2/latexml.error.log
    LogLevel warn
    CustomLog /var/log/apache2/latexml.access.log combined
</VirtualHost>
```

Then;

    a2ensite latexml
    apache2ctl restart

To test you can use the following request generated by mediawiki while \sin x^2 is converted:

    curl -d 'format=xhtml&whatsin=math&whatsout=math&pmml&cmml&nodefaultresources&preload=LaTeX.pool&preload=article.cls&preload=amsmath.sty&preload=amsthm.sty&preload=amstext.sty&preload=amssymb.sty&preload=eucal.sty&preload=%5Bdvipsnames%5Dxcolor.sty&preload=url.sty&preload=hyperref.sty&preload=%5Bids%5Dlatexml.sty&preload=texvc&tex=literal:%5Csin+x%5E2' localhost:8888

The result should contain a very log file an the XML output in the end.