function get(block)
{
    console.log(block);
    var xhr = new XMLHttpRequest();
    xhr.onload = xhr.onerror = function()   {
                                                if (this.status == 200) 
                                                  document.getElementById(block).innerHTML = xhr.responseText;      
                                                else 
                                                  console.log('get error ' + this.status + block) ;   
                                            };
    xhr.open("GET", block, true);
    xhr.send();
}


var onready = function()
{
    console.log('document.onload');
    get('title');
    get('right');
    get('main');
    get('left');
    get('tags');
};
document.addEventListener("DOMContentLoaded", onready);