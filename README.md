BlastedMouseWheelBlock
======================

Blocks simultaneous scrolling of flash file and browser, including buggy chrome pepper flash plugin!

Usage:
Just call BlastedMouseWheelBlock.init(stage, flashID) somewhere in your code.
flashID is the id or name (or both) of your SWFObject attributes array. 
It's 'flashObject' by defaul but feel free to change it when you call .init() function.

You may have to change your attributes of the swfobject like this:
'
...
var attributes = {
    id:"flashObject",
  	name: "flashObject",
    style:"margin-top:25px;"
};
...
'
