#use Test::More tests => 1, import => ['!pass'];
use strict;
use warnings;

use FiveDeen::App;
use Dancer::Test;


sub main {

	use Dancer;

    load_app 'FiveDeen::App';

    my (@data1, @data2, @data3, @test_styles, @param1, @param2, @param3, @find);

    my $styles1 = [];

    my $styles2 = [];

    my $styles3 = [];

    # test data1 start

    $data1[0] = "simpleCircleSymbol";

    $data1[1] = "symbol_1";

    $data1[2] = "a";

    $data1[3] = 50;

    $test_styles[0] = "stroke:#138788;stroke-width:2px;fill:#00ffcc";

    $test_styles[1] = "stroke:#00ff00;stroke-width:4px;fill:#ddffcc";

    map { push($styles1, {style => $_ }  );  } @test_styles;

    $data1[4] = $styles1;

    # test data1 end


    # test data2 start

    $data2[0] = "simpleCircleSymbol";

    $data2[1] = "symbol_2";

    $data2[2] = "b";

    $data2[3] = 50;

    $test_styles[0] = "stroke:#1387dd;stroke-width:1px;fill:#ffffcc";

    $test_styles[1] = "stroke:#00ffcc;stroke-width:8px;fill:#ddffff";

    map { push($styles2, {style => $_ }  );  } @test_styles;

    $data2[4] = $styles2;

    # test data2 end

    # test data3 start

    $data3[0] = "simpleCircleSymbol";

    $data3[1] = "symbol_3";

    $data3[2] = "c";

    $data3[3] = 50;

    $test_styles[0] = "stroke:#00ff00;stroke-width:5px;fill:#00ffcc";

    $test_styles[1] = "stroke:#00ff00;stroke-width:5px;fill:#ffffcc";

    map { push($styles3, {style => $_ }  );  } @test_styles;

    $data3[4] = $styles3;

    # test data3 end
    
 
 
 
    my $library = FiveDeen::App->create_library();
    

    $param1[0] = FiveDeen::App->create_symbol(@data1);

    $param1[1] = $library; 

    $param2[0] = FiveDeen::App->create_symbol(@data2);

    $param2[1] = $library;

    $param3[0] = FiveDeen::App->create_symbol(@data3);

    $param3[1] = $library;
 

    # printf FiveDeen::App->add_symbol_to_library(@param);

    FiveDeen::App->add_symbol_to_library(@param1);

    FiveDeen::App->add_symbol_to_library(@param2);

    FiveDeen::App->add_symbol_to_library(@param3);


    # printf FiveDeen::App->show_library($library);


    # $find[0] = $data1[1];

    $find[0] = "symbol_1";

    $find[1] = $library;


    
    # printf FiveDeen::App->remove_symbol_from_library(@find);

    printf FiveDeen::App->get_symbol_from_library(@find);


}

main();

# response_content_is [GET => '/test'], "Hello", 
#        "got expected response content for GET /test";
# response_content_is [GET => '/test'];

