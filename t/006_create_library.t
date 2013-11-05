#use Test::More tests => 1, import => ['!pass'];
use strict;
use warnings;

use FiveDeen::App;
use Dancer::Test;


sub main {

	use Dancer;

    load_app 'FiveDeen::App';

    my (@data, @test_styles, @param);

    my $styles = [];

    # test data

    $data[0] = "simpleCircleSymbol";

    $data[1] = "symbol_1";

    $data[2] = "a";

    $data[3] = 50;

   

    $test_styles[0] = "stroke:#138788;stroke-width:2px;fill:#00ffcc";

    $test_styles[1] = "stroke:#00ff00;stroke-width:4px;fill:#ddffcc";

    map { push($styles, {style => $_ }  );  } @test_styles;

    $data[4] = $styles;
 
 
 
    my $library = FiveDeen::App->create_library();
    

    $param[0] = FiveDeen::App->create_symbol(@data);

    $param[1] = $library; 


    printf FiveDeen::App->add_symbol_to_library(@param);



    #$param[0] = FiveDeen::App->create_symbol(@data);

    #$param[1] = $library; 


    #printf FiveDeen::App->create_library(@param);




}

main();

# response_content_is [GET => '/test'], "Hello", 
#        "got expected response content for GET /test";
# response_content_is [GET => '/test'];

