package FiveDeen::App;
use Dancer ':syntax';
use Dancer::Plugin::Database;

use File::Slurp qw(read_file write_file);

use File::Spec::Functions qw(rel2abs);
use File::Basename;


our $VERSION = '0.1';

# ---------------------------------------------------------------------------
# hooks

hook before_template => sub {
       my $tokens = shift;
       # $tokens->{'symbols'} = config->{symbols}; 
       $tokens->{'title'} = config->{appname}; 
       $tokens->{'width'} = config->{maps}{width};
       $tokens->{'height'} = config->{maps}{height};
};

# ---------------------------------------------------------------------------

# main page
get '/' => sub {
	template 'index', {
               # 'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },  
               #'title' => config->{appname},  
           
       };
};

# the input form (post/get)

get '/form' => sub {
	
	# test only
	# my $data = read_json_file(config->{lib}{json});
	
	template 'form', {
               #'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef },  
               #'title' => config->{appname},
               #'symbols' => $data->{symbols},              
       };
};

post '/form' => sub {
	
	my $incoming_string = write_json_file(config->{string}{json},string_to_json(params->{data}));
	
	# match incoming string (string.json) against font.json and save result to sequence.json
	# my $merged_string = write_json_file(config->{maps}{json},font_to_sequence(read_json_file(config->{string}{json}),read_json_file(config->{font}{json})));
	my $mapped_string = write_json_file(config->{sequence}{json},font_to_sequence(read_json_file(config->{string}{json}),read_json_file(config->{lib}{json})));
	
	my $seqdata = read_json_file(config->{sequence}{json});
	# my $seqdata = read_json_file(config->{maps}{json});
    
    my $div = config->{maps}{div};
    my $offset = config->{maps}{offset};
    # my $width = config->{maps}{width};
    # my $height = config->{maps}{height};

    # my $offset = (config->{maps}{width}/config->{maps}{div});

    #my $html_path = request->uri_base;	
	
    
    my $maps = from_json(set_maps($seqdata,$div,$offset));
	
	template 'form', {
		       'data' => params->{data},
		
		       # 'log' => $html_path, 
		       #'title' => config->{appname},
		 
               #'header' =>  template 'header.tt', {title => config->{appname},}, { layout => undef }, 
               'svg' =>  template 'embedded_svg.tt', { maps => $maps->{maps}, offset => $offset,  },{ layout => undef },              
       };
	
	
	# redirect '/form';
};

#  the viewer
get '/svg' => sub {
	
	# next step: form request of userdata (just a test sequence)
	#my @userdata = (1,2,4,1,5,1,6);	
	#my $newdata = write_json_file(config->{sequence}{json},set_sequence(@userdata));

    my $seqdata = read_json_file(config->{sequence}{json});
    
    my $div = config->{maps}{div};
    my $offset = config->{maps}{offset};
    # my $offset = (config->{maps}{width}/config->{maps}{div});

    my $maps = from_json(set_maps($seqdata,$div,$offset));

    
    template 'full_screen', {
     
               # 'header' =>  template 'header.tt', { title => config->{appname}, },{ layout => undef },  

               #'title' => config->{appname},
              
               'svg' =>  template 'embedded_svg.tt', { maps => $maps->{maps}, offset => $offset, },{ layout => undef },
               
               
               
       };
};

# the symbols library form (post/get)

get '/library' => sub {
	
    my $fivedeen_dbh = database('fivedeen');
    my $data = read_json_file(config->{lib}{json});

    template 'library',{symbols => $data->{symbols}}, 

};



get '/include' => sub {
	content_type 'text/ecmascript' ;
	my $data = read_json_file(config->{lib}{json});
	
	template 'include',{symbols => $data->{symbols}}, { layout => undef },   
};


get '/symbols' => sub {
	send_file config->{symbols};
};

#---------------------------------------------------------------------------
# SUPPORT Routines
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
# incoming string is disassembled and converted to json structure
sub string_to_json {
	
	my @data = split('',shift);
	my $key = "character";
	
	my $content = { string => []};
	
	map {push ($content->{string}, { $key => $_}) } @data;
	
	return to_json($content);
	
}
# ---------------------------------------------------------------------------
# match incoming string (string.json) against font.json and save result to sequence.json
sub font_to_sequence {
	
	my ($string, $font) = @_; 
	my @keys =  ( "character", "name");
	
	my $count = 0;
	my $character = "null";
	my $name = "null";
	
	my $sequence = { sequence => []};
	
	map { $name = compare_character($_->{character},$font); push ($sequence->{sequence},{$keys[0] => $_->{character}, $keys[1] => $name}) } @{$string->{string}};
	
	return to_json($sequence);
	
}
# ---------------------------------------------------------------------------
# support routine: identify character in font.json, used in font_to_sequence

sub compare_character {
	
    my ($character, $lib) = @_; 
    # my $name = "symbol_0";
    my $name = "";

    # map {  if ($_->{character} eq $character) { $name = $_->{name}; }   } @{$lib->{symbols}};
    map {     
        map { if ($_->{character} eq $character) { $name = $_->{name}; } } @{$_->{symbol}};
        }  @{$lib->{symbols}};
	
    return $name;	
}


# ---------------------------------------------------------------------------
true;

