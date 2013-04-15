/**
 * symbols.js

 * Symbol library 1.0
 * Michael Kuegeler 1/2013
 * 
 * * Copyright 2013 Michael Kuegeler
 * 
 * 
 */
///////////////////////////////////////////////////////////////////////////////
function Symbols ()
{
	
	
	this.xmlns = "http://www.w3.org/2000/svg";
	this.xlinkNS = "http://www.w3.org/1999/xlink"; 	

	this.id = Math.random().toString();
	
	// the parent node of all symbols
	this.layer = document.getElementsByTagName("defs").item(0).id;
	
	// offset used for boundary box position
	this.offset = 0.25;
	
}
///////////////////////////////////////////////////////////////////////////////
// Global functions used in symbol libraries
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.setNS = function(value)
{
            this.xmlns = value;
}
Symbols.prototype.getNS = function()
{
            return this.xmlns;
} 
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.setxlinkNS = function(value)
{
            this.xlinkNS = value;
}
Symbols.prototype.getxlinkNS = function()
{
            return this.xlinkNS;
}

///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.setID = function(value)
{
            this.id = value;
}
Symbols.prototype.getID = function()
{
            return this.id;
}

///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.setLayer = function(value)
{
            this.layer = value;
}
Symbols.prototype.getLayer = function()
{
            return this.layer;
}
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.setOffset = function(value)
{
            this.offset = value;

}
Symbols.prototype.getOffset = function()
{
            return this.offset;
}
///////////////////////////////////////////////////////////////////////////////
// SUPPORT functions
///////////////////////////////////////////////////////////////////////////////
// Create a "Use" element
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.use = function(href,transform)
{
	
	var use = document.getElementById(href);	
	
	var use = document.createElementNS(this.getNS(),"use"); 
	    
	    use.setAttributeNS(this.getxlinkNS(),"xlink:href","#"+href); 	    
	    
	    use.setAttribute("transform",transform);	    
					
        document.getElementById(document.getElementsByTagName("svg").item(0).id).appendChild(use);
     
}

///////////////////////////////////////////////////////////////////////////////
// The SYMBOL Library: Start
///////////////////////////////////////////////////////////////////////////////
// 1. a simple circle
Symbols.prototype.simpleCircleSymbol = function(id,radius,style)
{
    var offset = (radius*this.getOffset());  
	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	

	var group = document.createElementNS(this.getNS(),"g");

	    //group.setAttribute("id",id); 
	    group.setAttribute("transform","translate("+(radius+offset)+","+(radius+offset)+")");
	
    var circle = document.createElementNS(this.getNS(),"circle");

        circle.setAttribute("cx",0); 
        circle.setAttribute("cy",0);                
        circle.setAttribute("r",radius);
        circle.setAttribute("style",style);		
	    // circle.setAttribute("class","symbol_1");		
		
	    group.appendChild(circle);	
	    symbol.appendChild(group);
	    			
        document.getElementById(this.getLayer()).appendChild(symbol);
     
} 

///////////////////////////////////////////////////////////////////////////////
// 2. a simple square
Symbols.prototype.simpleSquareSymbol = function(id,radius,style)
{
    //var offset = (radius*0.75); 

    var offset = (radius*((0.5)+this.getOffset())); 
    
    var dim = (radius*2);  
	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	

	var group = document.createElementNS(this.getNS(),"g");

	     
	    group.setAttribute("transform","translate("+(radius-offset)+","+(radius-offset)+")");
	
    var rect = document.createElementNS(this.getNS(),"rect");

        rect.setAttribute("x",0);
        rect.setAttribute("y",0);

	    rect.setAttribute("width",dim);
        rect.setAttribute("height",dim); 

        rect.setAttribute("rx",0.5);
		rect.setAttribute("ry",0.5);
		
	    rect.setAttribute("style",style);	
	    group.appendChild(rect);	
	
	    symbol.appendChild(group);
	    			
        document.getElementById(this.getLayer()).appendChild(symbol);
     
}

///////////////////////////////////////////////////////////////////////////////
// 2. a combined square and circle
Symbols.prototype.combinedSquareCircleSymbol = function(id,radius,style_1,style_2)
{
    //var offset = (radius*0.75); 

    var offset = (radius*((0.5)+this.getOffset())); 
    
    var dim = (radius*2); 
    
    // offset between outer rectangle  and inner circle
    var factor = 0.1;
	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	

	var group = document.createElementNS(this.getNS(),"g");

	     
	    group.setAttribute("transform","translate("+(radius-offset)+","+(radius-offset)+")");
	
    var rect = document.createElementNS(this.getNS(),"rect");

        rect.setAttribute("x",0);
        rect.setAttribute("y",0);

	    rect.setAttribute("width",dim);
        rect.setAttribute("height",dim); 

        rect.setAttribute("rx",(dim/8));
		rect.setAttribute("ry",(dim/8));
		
  	var circle = document.createElementNS(this.getNS(),"circle");

        circle.setAttribute("cx",radius); 
        circle.setAttribute("cy",radius);                
        circle.setAttribute("r",(radius-(radius*factor)) );
        circle.setAttribute("style",style_1);		

        group.appendChild(circle);
		
	    rect.setAttribute("style",style_2);	
	    group.appendChild(rect);	
	    symbol.appendChild(group);
	    			
        document.getElementById(this.getLayer()).appendChild(symbol);
     
}
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.singleLetterSymbol_A = function(id,radius,style_1,style_2)
{
	// Capital letter A
	
	//  <text x="250" y="150" 
	//        font-family="Verdana" font-size="55" fill="blue" >
	//    Hello, out there
	//  </text>
	
	var data = "A";
	var offset = (radius*((0.5)+this.getOffset())); 
	
	var dim = (radius*2); 
  	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	
	

	var group = document.createElementNS(this.getNS(),"g");
	     
	    group.setAttribute("transform","translate("+(radius-offset)+","+(radius-offset)+")");
	
	var text = document.createElementNS(this.getNS(),"text");
	var textnode = document.createTextNode(data);
	
	    text.setAttribute("x",(radius/13.7));
        text.setAttribute("y",dim);
        text.setAttribute("fill",style_1);
        text.setAttribute("font-size",(dim*1.37));
        text.appendChild(textnode);

        group.appendChild(text);

   	var rect = document.createElementNS(this.getNS(),"rect");

        rect.setAttribute("x",0);
        rect.setAttribute("y",0);
	    rect.setAttribute("width",dim);
        rect.setAttribute("height",dim); 
        rect.setAttribute("style",style_2);	
        group.appendChild(rect);

        	
	    symbol.appendChild(group);
	    document.getElementById(this.getLayer()).appendChild(symbol);
		
}

///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.singleLetterSymbol_B = function(id,radius,style_1,style_2)
{
	// Capital letter B
	
	//  <text x="250" y="150" 
	//        font-family="Verdana" font-size="55" fill="blue" >
	//    Hello, out there
	//  </text>
	
	var data = "B";
	var offset = (radius*((0.5)+this.getOffset())); 
	
	var dim = (radius*2); 
  	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	
	

	var group = document.createElementNS(this.getNS(),"g");
	     
	    group.setAttribute("transform","translate("+(radius-offset)+","+(radius-offset)+")");
	
	var text = document.createElementNS(this.getNS(),"text");
	var textnode = document.createTextNode(data);
	
	    text.setAttribute("x",(radius/13.7));
        text.setAttribute("y",dim);
        text.setAttribute("fill",style_1);
        text.setAttribute("font-size",(dim*1.37));
        text.appendChild(textnode);

        group.appendChild(text);

   	var rect = document.createElementNS(this.getNS(),"rect");

        rect.setAttribute("x",0);
        rect.setAttribute("y",0);
	    rect.setAttribute("width",dim);
        rect.setAttribute("height",dim); 
        rect.setAttribute("style",style_2);	
        group.appendChild(rect);

        	
	    symbol.appendChild(group);
	    document.getElementById(this.getLayer()).appendChild(symbol);
		
}
///////////////////////////////////////////////////////////////////////////////

Symbols.prototype.singleLetterSymbol_C = function(id,radius,style_1,style_2)
{
	// Capital letter C
	
	//  <text x="250" y="150" 
	//        font-family="Verdana" font-size="55" fill="blue" >
	//    Hello, out there
	//  </text>
	
	var data = "C";
	var offset = (radius*((0.5)+this.getOffset())); 
	
	var dim = (radius*2); 
  	
	var symbol = document.createElementNS(this.getNS(),"symbol"); 
	    symbol.setAttribute("id",id);	
	
	

	var group = document.createElementNS(this.getNS(),"g");
	     
	    group.setAttribute("transform","translate("+(radius-offset)+","+(radius-offset)+")");
	
	var text = document.createElementNS(this.getNS(),"text");
	var textnode = document.createTextNode(data);
	
	    text.setAttribute("x",(radius/16.0));
        text.setAttribute("y",(dim*0.96));
        text.setAttribute("fill",style_1);
        text.setAttribute("font-size",(dim*1.30));
        text.appendChild(textnode);

        group.appendChild(text);

   	var rect = document.createElementNS(this.getNS(),"rect");

        rect.setAttribute("x",0);
        rect.setAttribute("y",0);
	    rect.setAttribute("width",dim);
        rect.setAttribute("height",dim); 
        rect.setAttribute("style",style_2);	
        group.appendChild(rect);

        	
	    symbol.appendChild(group);
	    document.getElementById(this.getLayer()).appendChild(symbol);
		
}
  
///////////////////////////////////////////////////////////////////////////////
 
///////////////////////////////////////////////////////////////////////////////
// The SYMBOL Library: End
///////////////////////////////////////////////////////////////////////////////
// initialize the library in SVG file
// get parameters and create initial object canvas
// init can be called in svg root node: onload="new Symbols().init(evt)"
// currently, init() is defined in the svg file directly.
///////////////////////////////////////////////////////////////////////////////
Symbols.prototype.init = function()
{
	
var symbols = new Symbols();

symbols.simpleCircleSymbol("symbol_1");


}
///////////////////////////////////////////////////////////////////////////////
