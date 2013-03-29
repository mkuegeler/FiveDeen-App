use Test::More tests => 1, import => ['!pass'];
use strict;
use warnings;

use FiveDeen::App;
use Dancer::Test;

{
    use Dancer;

    load_app 'FiveDeen::App';
    
    setting views => path('/home/perldev/workspace/FiveDeen-App/t/views');
    
    get '/' => sub {
        template 'index', {}, { layout => undef };
    };

    my $app = FiveDeen::App->setPoints(25,5,50);

    get '/setPoints' => sub {

        # template 'index', {content => $app->{grid}, values => $app}, { layout => undef };
        template 'index', {values => $app}, { layout => undef };

    };

    
}

# my $app = FiveDeen::App->setPoints(length => 25,div => 5,offset => 50);
# is scalar(@apps), 1, "1 methods exist";

# foreach my $value (@{$app->{grid}}) {

# printf "translate ($value->{x},($value->{y} )\n";

# }

# print $app;

# print "translate ($app->{grid}[0]->{x},$app->{grid}[0]->{y})\n";
# print "translate ($app->{grid}[1]->{x},$app->{grid}[1]->{y})\n";
# print "translate ($app->{grid}[2]->{x},$app->{grid}[2]->{y})\n";


response_content_is [GET => '/setPoints'];