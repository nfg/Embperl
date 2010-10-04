function set_grid_display(doc, elm, display)
    {
    var elements = elm.getElementsByTagName('table');
    for (var i = 0; i < elements.length ; i++)
        {
        if(elements[i].className.search('cGridTable') != -1)
            {
            elements[i].style.display = display;
            }
        }
    }

function set_display(doc, value,display)
    {
    var elm ;
    if (elm = doc.getElementById(value))
        {
        elm.style.display = display ;
        set_grid_display(doc, elm,display);
        }
    j = 10 ;
    dummy= value + j;
    while (elm = doc.getElementById(dummy) )
        {
        elm.style.display = display ;
        j++ ;
        dummy= value + j;
        }
    }

function set_class(doc, name, classval)
    {
    var obj = doc.getElementById(name) ;
    if (obj)
        obj.className = classval ;
    }

function show_id_setobj(doc, value, name)
    {
    var obj = doc.getElementById(name) ;
    if (obj)
        obj.value = value ;

    set_display(doc, value, "") ;
    }


function tab_selected(doc, value, name)
    {
    var obj = doc.getElementById(name) ;

    if (obj && obj.value)
            {
            set_display(doc, obj.value, "none") ;
            set_class(doc, '__tabs_' + obj.value, 'cTabDivOff') ;
            }

    set_class(doc, '__tabs_' + value, 'cTabDivOn') ;
    show_id_setobj(doc, value, name) ;
    }

function show_selected(doc, obj)
    {
    var i ;
    var x = obj.selectedIndex ;
    var name = obj.name ;
    var elm ;
    var baseid = name + '-'  ;
    for (i=0;i<obj.options.length;i++)
        {
        if (obj.options[i].value != '')
            {
            elm = doc.getElementById(baseid + (i + 1)) ;
            if (elm)
                {
                if (i == x)
                    {
                    elm.style.display = "" ;
                    }
                else
                    {
                    elm.style.display = "none" ;
                    }
                }
            j = 10 ;
	    dummy = baseid + i + '-' + j;
            while (elm = doc.getElementById(dummy) )
                {
                if (i == x)
                    {
                    elm.style.display = "" ;
                    }
                else
                    {
                    elm.style.display = "none" ;
                    }
                j++ ;
	        dummy = baseid + i + '-' + j;
                }
            }
        }
    }


function show_checked(doc, obj)
    {
    var i ;
    var x = obj.checked?0:1 ;
    var name = obj.name ;
    var elm ;
    var baseid = name + '-'  ;
    for (i=0;i<2;i++)
        {
        elm = doc.getElementById(baseid + i) ;
        if (elm)
            {
            if (i == x)
                {
                elm.style.display = "" ;
                }
            else
                {
                elm.style.display = "none" ;
                }
            }
        j = 10 ;
        dummy = baseid + i + '-' + j;
        while (elm = doc.getElementById(dummy) )
            {
            if (i == x)
                {
                elm.style.display = "" ;
                }
            else
                {
                elm.style.display = "none" ;
                }
            j++ ;
            dummy = baseid + i + '-' + j;
            }
        }
    }

function show_radio_checked(doc, obj,x,max)
    {
    var i ;
    var name = obj.name ;
    var elm ;
    var baseid = name + '-'  ;

    for (i=0;i<=max;i++)
        {
        elm = doc.getElementById(baseid + i) ;
        if (elm)
            {
            if (i == x)
                {
                elm.style.display = "" ;
                }
            else
                {
                elm.style.display = "none" ;
                }
            }
        j = 10 ;
        dummy = baseid + i + '-' + j;
        while (elm = doc.getElementById(dummy) )
            {
            if (i == x)
                {
                elm.style.display = "" ;
                }
            else
                {
                elm.style.display = "none" ;
                }
            j++ ;
        dummy = baseid + i + '-' + j;
            }
        }
    }
function submitvalue (form, name, value)
    {
    var e=form.ownerDocument.createElement('input');
    e.type='hidden';
    e.name=name;
    e.value=value;
    form.appendChild(e);
    form.submit()    
    }

function addremoveInitOptions (doc, src, dest, send, removesource)
    {
    var i ;
	var j ;
	var found = 0 ;
	var val ;
    var vals = send.value.split("\t") ;
    for (i = 0; i < vals.length; i++)
        {
        val = vals[i] ;
        found = 0 ;
        for (j = 0; j < src.length; j++)
            {
            if (src.options[j].value == val)
        	   {
        	   found = 1 ;
        	   break ;
        	   }
            }
        if (found)
        	{
            var newopt = doc.createElement('OPTION') ;
            var oldopt = src.options[j] ;
            newopt.text = oldopt.text ;
            newopt.value = oldopt.value ;
            dest.options.add(newopt) ;
        	}
        }
     if (removesource)
         {
         for (i = 0; i < src.length; i++)
             {
             val = src.options[i].value ;
             for (j = 0; j < vals.length; j++)
                 {
                 if (vals[j] == val)
        	         {
                     src.options[i] = null ;
        	         i-- ;
        	         break ;
        	         }
                 }
             }
         }
     }

function addremoveBuildOptions (dest, send)
    {
    var i ;
    var val = '' ;
    for (i = 0; i < dest.length; i++)
        {
        val += dest.options[i].value ;
        if (i < dest.length - 1)
            val += "\t" ;
        }
    send.value=val ;
    }

function addremoveAddOption (doc, src, dest, send, removesource)
    {
    if (src.selectedIndex >= 0)
        {
        var newopt = doc.createElement('OPTION') ;
        var oldopt = src.options[src.selectedIndex] ;
        newopt.text = oldopt.text ;
        newopt.value = oldopt.value ;
        dest.options.add(newopt) ;
        if (removesource)
            src.options[src.selectedIndex] = null ;
        addremoveBuildOptions (dest, send) ;
        }
    else
        alert ("Bitte einen Eintrag zum Hinzufügen auswählen") ;

    }

function addremoveRemoveOption (doc, src, dest, send, removesource)
    {
    if (dest.selectedIndex >= 0)
        {
        if (removesource)
			{
            var newopt = doc.createElement('OPTION') ;
            var oldopt = dest.options[dest.selectedIndex] ;
            newopt.text = oldopt.text ;
            newopt.value = oldopt.value ;
            src.options.add(newopt) ;
            }
        //dest.options.remove(dest.selectedIndex) ;
        dest.options[dest.selectedIndex] = null ;
        addremoveBuildOptions (dest, send) ;
        }
    else
        alert ("Bitte einen Eintrag zum Entfernen auswählen") ;

    }

// -----------------------------------------------------------------------------



var Grid = Class.create() ;

Grid.prototype = {

initialize: function (tableelement, rowelement, maxelement)
    {
    this.rowelement   = rowelement ;
    this.maxelement   = maxelement ;
    this.tableelement = tableelement ;
    Event.observe(this.tableelement, "click", this.onClick.bindAsEventListener(this));
    Event.observe(this.tableelement, "focus", this.onClick.bindAsEventListener(this));
    Event.observe(this.tableelement, "keyup", this.onClick.bindAsEventListener(this));

    rows = this.tableelement.getElementsByTagName('tr'); 
    lastrow = rows[rows.length - 1] ;
    newid    = this.tableelement.id ;    
    newid    = newid + '-row-' ;
    lastid   = lastrow.id ;
    idlength = newid.length ;
    this.lastnum  = parseInt (lastid.substr(idlength)) ;
    if (isNaN(this.lastnum))
        this.lastnum = -1 ;
    },
    
    
addRow: function ()
    {
    var rows = this.tableelement.getElementsByTagName('tr'); 
    var lastrow = rows[rows.length - 1] ;

    this.lastnum  = this.lastnum + 1 ;
    var inserttext = this.rowelement.innerHTML ;
    var newtext  = inserttext.replace (/%row%/gi, this.lastnum) ;
    newtext  = newtext.replace (/<tbody>/gi, '') ;
    newtext  = newtext.replace (/<\/tbody>/gi, '') ;
    newtext  = newtext.replace (/<x-script/gi, '<script') ;
    newtext  = newtext.replace (/<\/x-script/gi, '</script') ;
    new Insertion.After (lastrow, newtext) ;
    this.maxelement.value = this.lastnum + 1 ;
    },

focusRow: function ()
    {
    var next = this.currRow ;
    if (next && next.className == 'cGridRow')
        {
        next.className='cGridRowSelected' ;
        while (next && (next.tagName != 'INPUT' || next.tagName != 'SELECT'))
            {
            next = next.firstChild ;
            }
        if (next)
            next.focus() ;
        }
    },

delRow: function (row)
    {
    if (row != undefined)
        this.currRow = row ;
    if (this.currRow)
        {
        var next = this.currRow.nextSibling ;
        var p = this.currRow.parentNode ;
        p.removeChild(this.currRow) ;
        this.currRow = next ;
        this.focusRow () ;
        }
    },

upRow: function (row)
    {
    if (row != undefined)
        this.currRow = row ;
    if (this.currRow)
        {
        var prev = $(this.currRow).previous () ;
        if (prev && prev.className == 'cGridRow')
            {
            var currorder = this.currRow.getElementsByTagName('input'); 
            var prevorder = prev.getElementsByTagName('input'); 
            var n = currorder[0].value ;
            currorder[0].value = prevorder[0].value ;
            prevorder[0].value = n ;

            var p = this.currRow.parentNode ;
            var currdata = p.removeChild(this.currRow) ;
            this.currRow = p.insertBefore(currdata, prev) ;

            this.focusRow () ;
            }
        }
    },

downRow: function (row)
    {
    if (row != undefined)
        this.currRow = row ;
    if (this.currRow)
        {
        var next = $(this.currRow).next () ;
        if (next && next.className == 'cGridRow')
            {
            var currorder = this.currRow.getElementsByTagName('input'); 
            var nextorder = next.getElementsByTagName('input'); 
            var n = currorder[0].value ;
            currorder[0].value = nextorder[0].value ;
            nextorder[0].value = n ;

            var next2 = next.next () ;
            var p = this.currRow.parentNode ;
            var currdata = p.removeChild(this.currRow) ;
            this.currRow = p.insertBefore(currdata, next2) ;

            this.focusRow () ;
            }
        }
    },


onClick: function (e)
    {
    var elem = e.target?e.target:e.srcElement ;
    if (e.type == 'keyup' && ((e.which && e.which == e.DOM_VK_ADD) || e.keyCode == 107) && e.altKey)
        {
        this.addRow () ;
        e.cancelBubble = true ;
        return false ;
        }

    var p = elem ;
    while (p && p.tagName != 'TR')
        {
        p = p.parentNode ;
        }
    if (p)
        {
        if (this.currRow)
            this.currRow.className='cGridRow' ;
        
        if (p.className == 'cGridRow')
            {
            p.className='cGridRowSelected' ;
            this.currRow=p ;
            }
        else
            {
            this.currRow=null ;
            }
        if (this.currRow && e.type == 'keyup' && ((e.which && e.which == e.DOM_VK_SUBTRACT) || e.keyCode == 109) && e.altKey)
            {
            this.delRow (this.currRow) ;
            e.cancelBubble = true ;
            return false ;
            }
        }
    //alert ('t='+elem.tagName +' p='+ p.id+' c='+p.className) ;
    }
 
 }   

