#!/usr/bin/perl
use AnyEvent::HTTPD;
use Data::Dumper;
use strict;

my $headers_ok = { 'Content-Type'  => 'text/html', 'Cache-Control' => 'max-age=193600', 'Expires' => undef };
warn "IP $ENV{'IP'} PORT $ENV{'PORT'}\n" ;

my $httpd = AnyEvent::HTTPD->new (ip => $ENV{'IP'}, port => $ENV{'PORT'});

$httpd->reg_cb (
                    '/'          => \&static,
                    '/title'     => \&title,
                    '/right'     => \&right,
                    '/main'      => \&main,
                    '/left'      => \&left,
                    '/tags'      => \&tags,
                    '/index.js'  => \&indexjs,
                    '/post_list' => \&post_list,
                    '/new_post'  => \&new_post,
                    '/favicon.ico'=> \&static,
                    
                );

$httpd->run; # making a AnyEvent condition variable would also work


sub indexjs()
{
    my ($httpd, $req) = @_;
    my $url = $req->url();
    my $filename = '';
    $url =~ m@/(.*)\??@;
    if ( $1 ) { $filename = $1 } else { $filename = 'index.html' }
    warn "URL $url FILENAME $filename\n";
    
    warn "PARAMS ".Dumper $req->vars()."\n";
    my $content = read_file($filename) or http404($req);
    $req->respond   ([
                        200, 'OK', 
                        { 'Content-Type'  => 'script/javascript', 'Cache-Control' => 'max-age=193600' },
                        $content
                    ]);    
    $httpd->stop_request;                    
}

sub static()    
{
    my ($httpd, $req) = @_;
    my $url = $req->url();
    my $filename = '';
    $url =~ m@/(.*)\??@;
    if ( $1 ) { $filename = $1 } else { $filename = 'index.html' }
    warn "URL $url FILENAME $filename\n";
    
    warn "PARAMS ".Dumper $req->vars()."\n";
    my $content = read_file($filename) or http404($req);
    $req->respond   ([
                        200, 'OK', 
                        $headers_ok,
                        $content
                    ]);    
    $httpd->stop_request;                    
}


sub tags()
{
    my ($httpd, $req) = @_;

    $req->respond   ([
                        200, 'OK', 
                        $headers_ok,
                        'TAGS'
                    ]);    
    $httpd->stop_request;                    
}

sub main()
{
    my ($httpd, $req) = @_;

    $req->respond   ([
                        200, 'OK', 
                        $headers_ok,
                        'MAIN'
                    ]);    
    $httpd->stop_request;                    
}


sub title()
{
    my ($httpd, $req) = @_;

    $req->respond   ([
                        200, 'OK', 
                        $headers_ok,
                        'TiTlE'
                    ]);    
    $httpd->stop_request;                    
}


sub post_list()
{
    my ($httpd, $req) = @_;
    $req->respond   ([
                        200, 'OK', 
                        $headers_ok,
                        "Список постов"
                    ]);    
    $httpd->stop_request;        
}

sub new_post()
{
    my ($httpd, $req, $header, $tags, $text) = @_;
    warn "new_post\n";
    $req->respond   ([
                        200, 'OK', 
                        { 'Content-Type'  => 'text/html', 'Cache-Control' => 'max-age=193600', 'Expires' => undef },
                        "Успешно добавлен пост"
                    ]);    
    $httpd->stop_request;        
}

sub http404()
{
    warn "Error: 404\n";
    shift->respond   ([
                        404, 'Error: file not found',
                        { 'Content-Type'  => 'text/html'  },
                        'No file with name like this <br> The info disappears <br> Entropy only left'
                    ]);
}

sub read_file()
{
    my $file = shift or warn("read_file: no arg"), return undef;
    open(FILE, "<$file") or return undef;  
    local $/ = undef;
    return <FILE>;
    close FILE;
}

