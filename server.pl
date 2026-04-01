use strict;
use warnings;

use Cwd qw(abs_path);
use File::Spec;
use IO::Socket::INET;

my $root = abs_path('/app') || '/app';
my $server = IO::Socket::INET->new(
  LocalAddr => '0.0.0.0',
  LocalPort => 8080,
  Listen    => 10,
  Reuse     => 1,
  Proto     => 'tcp',
) or die "Unable to start server: $!\n";

sub mime_type {
  my ($path) = @_;
  return 'text/html; charset=utf-8' if $path =~ /\.html?$/i;
  return 'text/css; charset=utf-8' if $path =~ /\.css$/i;
  return 'application/javascript; charset=utf-8' if $path =~ /\.js$/i;
  return 'application/json; charset=utf-8' if $path =~ /\.json$/i;
  return 'text/markdown; charset=utf-8' if $path =~ /\.md$/i;
  return 'image/svg+xml' if $path =~ /\.svg$/i;
  return 'image/png' if $path =~ /\.png$/i;
  return 'image/jpeg' if $path =~ /\.jpe?g$/i;
  return 'image/webp' if $path =~ /\.webp$/i;
  return 'text/plain; charset=utf-8';
}`

sub send_response {
  my ($client, $status, $message, $content_type, $body) = @_;
  $body //= '';

  print {$client} "HTTP/1.1 $status $message\r\n";
  print {$client} "Content-Type: $content_type\r\n";
  print {$client} 'Content-Length: ' . length($body) . "\r\n";
  print {$client} "Connection: close\r\n\r\n";
  print {$client} $body;
}

while (my $client = $server->accept) {
  my $request_line = <$client>;
  if (!defined $request_line) {
    close $client;
    next;
  }

  my ($method, $target) = $request_line =~ m{^([A-Z]+)\s+(\S+)\s+HTTP/};
  while (defined(my $header = <$client>)) {
    last if $header =~ /^\r?\n$/;
  }

  if (!$method || $method ne 'GET') {
    send_response($client, '405', 'Method Not Allowed', 'text/plain; charset=utf-8', "Method Not Allowed\n");
    close $client;
    next;
  }

  $target =~ s/\?.*$//;
  $target = '/index.html' if $target eq '/';

  if ($target =~ m{(?:^|/)\.\.(?:/|$)}) {
    send_response($client, '400', 'Bad Request', 'text/plain; charset=utf-8', "Bad Request\n");
    close $client;
    next;
  }

  $target =~ s{^/+}{};
  my $path = File::Spec->catfile($root, $target);

  if (-d $path) {
    $path = File::Spec->catfile($path, 'index.html');
  }

  if (-f $path) {
    open my $fh, '<:raw', $path or do {
      send_response($client, '500', 'Internal Server Error', 'text/plain; charset=utf-8', "Internal Server Error\n");
      close $client;
      next;
    };

    local $/;
    my $body = <$fh>;
    close $fh;

    send_response($client, '200', 'OK', mime_type($path), defined $body ? $body : '');
  } else {
    send_response($client, '404', 'Not Found', 'text/plain; charset=utf-8', "Not Found\n");
  }

  close $client;
}