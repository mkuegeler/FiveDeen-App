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

    my $offset = 50;

    my $seqname = config->{sequence}{json}; 
	
    template 'embedded_svg', {
               'data' =>  $data->{maps}, 

               'sequence' => getSequence($seqname),

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
# ---------------------------------------------------------------------------
true;

