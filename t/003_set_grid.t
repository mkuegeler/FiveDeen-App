use Test::More tests => 1;
# use Test::More import => ['!pass'];

use strict;
use warnings;


# the order is important
use FiveDeen::App;
use Dancer::Test;

#response_content_is [GET => '/'], "Hello, World", 
#        "got expected response content for GET /";


response_content_is [GET => '/'];

