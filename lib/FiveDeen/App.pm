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
};

# ---------------------------------------------------------------------------

get '/' => sub {
	template 'index', {
               'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },               
       };
};

get '/svg' => sub {

    my $seqdata = read_json_file(config->{sequence}{json});
    
    my $div = config->{maps}{div};
    my $offset = config->{maps}{offset};

    my $maps = from_json(set_maps($seqdata,$div,$offset));

    template 'embedded_svg', {

               'maps' => $maps->{maps},

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
# simple linear flow of coordinates, left to right, top down
sub set_linear_points {  
  
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
  

}
# ---------------------------------------------------------------------------
# get the maps.json merging sequence.json and grid
sub set_maps {

my ($seqdata, $div,$offset) = @_;  
my $length = @{$seqdata->{sequence}}; 

my $maps = { maps => []};
my $grid = from_json(set_linear_points($length,$div,($offset*2)));
 my @keys =  ( "name", "translate");
 
my $count = 0;


map { push ($maps->{maps},{$keys[0] =>$_->{name}, 
	             $keys[1] =>"$grid->{grid}[$count]->{x},$grid->{grid}[$count]->{y}"} 
	       ); $count++; 
	} @{$seqdata->{sequence}};

return to_json($maps);

}
# ---------------------------------------------------------------------------
# read,update write json from and to file
# read a file into hash, update hash, save hash back to file

sub read_json_file {
	
	my $filename = shift; 
	my $json = -e $filename ? read_file $filename : '{}';
    
	return from_json $json;
	
}


# ---------------------------------------------------------------------------
true;

