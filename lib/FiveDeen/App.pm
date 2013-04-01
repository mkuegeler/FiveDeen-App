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

# main page
get '/' => sub {
	template 'index', {
               'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },               
       };
};

# the input form (post/get)

get '/form' => sub {
	template 'form', {
               'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },               
       };
};

post '/form' => sub {
	
	my @data = split('',params->{data});
	
	template 'form', {
		       'data' => params->{data},
		       # 'log' => @data, 
		 
               'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },               
       };
	
	
	# redirect '/form';
};

#  the viewer
get '/svg' => sub {
	
	# next step: form request of userdata
	my @userdata = (1,2,4,1,2,1,2,1,2,4,1,2,1,2,1,2,4,1,2,1,2,1,2,4,1,2,1,2);
	
	# my $newdata = write_json_file(config->{sequence}{json},set_sequence(@userdata));

    my $seqdata = read_json_file(config->{sequence}{json});
    
    my $div = config->{maps}{div};
    my $offset = config->{maps}{offset};
    my $width = config->{maps}{width};
    my $height = config->{maps}{height};

    my $maps = from_json(set_maps($seqdata,$div,$offset));


    template 'embedded_svg', {

               'maps' => $maps->{maps},

               # 'log' => $log,

               'offset' => $offset, 
               'width' => $width, 
               'height' => $height,  
             
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
# create sequence.json 
sub set_sequence {

# sample: my @userdata = (1,2,4,1,2,1,2);
my @data = @_;   
my $key = "name";

my $sequence = { sequence => []};

map {push ($sequence->{sequence}, { $key => "symbol_$_"}) } @data;

return to_json($sequence);

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
sub write_json_file {
	
	my ($filename, $new) = @_; 
	
	my $json = -e $filename ? read_file $filename : '{}';
	my $old = from_json $json;
	
	write_file $filename, $new;
    
	return $new;
	
}


# ---------------------------------------------------------------------------
true;

