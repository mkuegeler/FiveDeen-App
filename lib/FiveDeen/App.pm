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

    
    

    my $seqname = config->{sequence}{json}; 
    my $seqjson = -e $seqname ? read_file $seqname : '{}';
    my $seqdata = from_json $seqjson;

    my $length = @{$seqdata->{sequence}}; 
    my $div = 2;
    my $offset = 50;

    my @grid = (6,2,50);

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
        translate1 => [ '0', '0' ],
        translate2 => [ '10', '10' ],
    
    }; 

    my $grid_hash = { grid => [{x=>0,y=>50},{x=>0,y=>100},{x=>0,y=>150},{x=>0,y=>200}]};



    # {"a":["text1","text2"],"b":["what","is","this"]}
    

	
    template 'embedded_svg', {
               'data' =>  $data->{maps}, 

               'grid' => to_json($grid_hash),

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
# test routes

get '/setGridRows' => sub {

       # my $grid_hash = { grid => [{x=>0,y=>50},{x=>0,y=>100},{x=>0,y=>150},{x=>0,y=>200}]};
       my @grid = setGridRows(10, 5, 50);
       # return "setGridRows";
       # return $grid_hash;

       return "$grid[2]->{x}, $grid[2]->{y}";


};

get '/setPoints' => sub {

  return setPoints();

};


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
# set grid in rows
# sample result: $keys[1] => "translate($grid[$count]->{x},$grid[$count]->{y})",

sub setGridRows {
	
	my ( $length, $div, $offset ) = @_;
	my @keys =  ( "x", "y");
	
	my @grid;
	
	my $x = 0; 
	my $y = 0;
	my $count = 0;
	
# check if div is larger than length	
   if ($div >= $length) { $div = $length; }	
	
   for (my $i=0; $i<$length; $i++) {	
	
		 while ($count < $div) {
			
		    push (@grid,{ $keys[0] => $x, $keys[1] => $y});
            $x = ($x+$offset);		
		    
		    $count++; 
		
		 }
	     $count = 0; $x = 0;	$y = ($y+$offset); 
	  
	    
    }

	return @grid;
}

#---------------------------------------------------------------------------
sub setPoints {  
  # body...
  # my $grid_hash = { grid => [{x=>0,y=>50},{x=>0,y=>100},{x=>0,y=>150},{x=>0,y=>200}]};
  my $tmp_hash = { grid => []};

  return $tmp_hash;


}
# ---------------------------------------------------------------------------
true;

