package FiveDeen::App;
use Dancer ':syntax';

use File::Slurp qw(read_file write_file);

use File::Spec::Functions qw(rel2abs);
use File::Basename;


our $VERSION = '0.1';

# ---------------------------------------------------------------------------
# hooks

hook before_template => sub {
       my $tokens = shift;

       $tokens->{'symbols'} = config->{symbols};
       $tokens->{'cgi_path'} = dirname(rel2abs($0));
       $tokens->{'html_path'} = $ENV{'DOCUMENT_ROOT'};
       # $tokens->{'app_path'} = dirname($ENV{'DOCUMENT_ROOT'});


       # my ($cgi_path,$html_path,$app_path) = (dirname(rel2abs($0)), $ENV{'DOCUMENT_ROOT'}, dirname($ENV{'DOCUMENT_ROOT'}));        

};

# ---------------------------------------------------------------------------

get '/' => sub {
	template 'index', {
               'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },               
       };
};

get '/svg' => sub {

	  my $mapname = config->{maps}{json}; 
	  my $json = -e $mapname ? read_file $mapname : '{}';
    my $data = from_json $json;

    my $gridname = config->{grid}{json}; 
    my $gridjson = -e $gridname ? read_file $gridname : '{}';
    my $default_grid = from_json $gridjson;
    

    my $seqname = config->{sequence}{json}; 
    my $seqjson = -e $seqname ? read_file $seqname : '{}';
    my $seqdata = from_json $seqjson;

    my $length = @{$seqdata->{sequence}}; 
    my $div = 2;
    my $offset = 50;

    # my @grid = (6,2,50);

    #my @grid = setGridRows($length,$div,$offset);

    # <% FOR f IN grid %>
    #    // new Symbols().use("Symbol_1","translate(<% f.x %>,<% f.y %>)");         
    # <% END %>


    # {"grid":
    #   [
    #    {"x":0,"y":0},
    #    {"x":0,"y":50},	
    #    {"x":0,"y":100},	
    #    {"x":0,"y":150},		
    #   ]
    # }

    # my $node_hash = {
    # a => [ 'text1', 'text2' ],
    # b => [ 'what',  'is', 'this' ],
    # };

    my $node_hash = {
        grid => [ '0', '0' ],
        
    
    }; 

    # my $grid_hash = { grid => [{x=>0,y=>50},{x=>0,y=>100},{x=>0,y=>150},{x=>0,y=>200}]};
    # my $grid_hash = setPoints(4,2,50);
    my $grid = from_json(setPoints($length,2,50));

    # {"a":["text1","text2"],"b":["what","is","this"]}
    # my $grid_hash = { grid => [{x=>0,y=>0},{x=>0,y=>0} ] };
    
	  # maps.json = grid & sequence

    my $maps = setMaps($seqdata,$grid);

    template 'embedded_svg', {

               'data' =>  $data->{maps}, 

               'sequence' => $seqdata->{sequence},   

               'grid' => $grid->{grid},

               'log' => $maps,

               'offset' => $offset,              
               'header' =>  template 'header.tt', { title => config->{appname}, },{ layout => undef },
               
               
       };
};


get '/include' => sub {
	content_type 'text/ecmascript' ;
	template 'include',{}, { layout => undef },   
};


get '/symbols' => sub {
	send_file config->{symbols};
};

#---------------------------------------------------------------------------

#---------------------------------------------------------------------------
# get the sequence json

sub getSequence {
	
	my $file = shift;
	
	my $json = -e $file ? read_file $file : '{}';
    my $data = from_json $json;

    my $length = @{$data->{sequence}}; 
	
	# return $data->{sequence}[0]->{name};
	# return length(@{$data->{sequence}});	
	# return length(@decoded_json);
	
	return $length;
	
}

#---------------------------------------------------------------------------
# simple linear flow of coordinates, left to right, top down
sub setPoints {  
  
  
  # my ( $length, $div, $offset ) = (10,2,50);  
  my ($length, $div, $offset) = @_;

  my @keys =  ( "x", "y");
  
  my $grid = { grid => []};
  
  my $x = 0; 
  my $y = 0;
  my $count = 0;
  
  # check if div is larger than length  
  if ($div >= $length) { $div = $length; } 
  
   for (my $i=0; $i<$length; $i++) {  
  
     while ($count < $div) {
      
        push ($grid->{grid},{ $keys[0] => $x, $keys[1] => $y});
            $x = ($x+$offset);    
        
        $count++; 
    
      }
       $count = 0; $x = 0;  $y = ($y+$offset); 
    
      
    }

  return to_json($grid);
  # return "[Flag: $flag], [Test: $test], [Div: $div], [Offset: $offset], [Length: $length]";

}
# ---------------------------------------------------------------------------
# get the maps.json by merging sequence.json and grid.json
sub setMaps {

my ($seqdata, $grid) = @_;  

# {"maps":
# [
#    {"name":"symbol_1","translate":"0,0",  "rotate":"0", "scale":"0"}, 
#    {"name":"symbol_1","translate":"100,0","rotate":"0", "scale":"0"},   
#    {"name":"symbol_3","translate":"200,0","rotate":"0", "scale":"0"},   
#    {"name":"symbol_4","translate":"300,0","rotate":"0", "scale":"0"},
#    {"name":"symbol_2","translate":"400,0","rotate":"0", "scale":"0"}  
# ]
# }

my $length = @{$seqdata->{sequence}}; 

return $length;


}
# ---------------------------------------------------------------------------
true;

