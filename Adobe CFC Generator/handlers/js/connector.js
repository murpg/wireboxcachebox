/*
ADOBE SYSTEMS INCORPORATED
 Copyright 2011 Adobe Systems Incorporated
 All Rights Reserved.

NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
terms of the Adobe license agreement accompanying it.  If you have received this file from a
source other than Adobe, then your use, modification, or distribution of it requires the prior
written permission of Adobe.
*/

//Author : Ram Kulkarni

function connectorUI (srcDomElm, targetDomElm)
{
	this.srcObj = $(srcDomElm).data(_orgSrcHtmlElmKeyName); //this is tableRowUI object
	this.targetElm = targetDomElm;
	this.connector;
	this.rf_remove;
	this.dbTableRelation;
	
	var _parentThis = this;

	this.init = function ()
	{
		_parentThis.redrawConnector();
		
		var targetObj =  $(_parentThis.targetElm).data(_uiObjKeyName);
		
		_parentThis.srcObj.connectors.push(_parentThis);
		targetObj.connectors.push(_parentThis);
		
		$(_parentThis.connector.node).dblclick(_parentThis.onDBClick);
		$(_parentThis.connector.node).hover(_parentThis.hoverIn, _parentThis.hoverOut);
		
		_parentThis.setupRelationship();
	}
	
	this.setupRelationship = function()
	{
		_parentThis.dbTableRelation = new dbRelation(); 
		var targetObj =  $(_parentThis.targetElm).data(_uiObjKeyName);

		_parentThis.dbTableRelation.srcRelName = targetObj.dbTable.name.split(' ').join('');
		_parentThis.dbTableRelation.targetRelName = _parentThis.srcObj.dbTable.name.split(' ').join('');

		_parentThis.srcObj.dbTable.relations.push(_parentThis.dbTableRelation);	
		targetObj.dbTable.relations.push(_parentThis.dbTableRelation);
			
		_parentThis.dbTableRelation.srcTableCol = new dbTableColPair(_parentThis.srcObj.dbTable,_parentThis.srcObj.col);
		_parentThis.dbTableRelation.targetTableCol = new dbTableColPair(targetObj.dbTable, targetObj.col);
		_parentThis.dbTableRelation.srcTable = _parentThis.srcObj.dbTable;
		_parentThis.dbTableRelation.targetTable = targetObj.dbTable;
		_parentThis.dbTableRelation.linkTableConditions.push(_parentThis.dbTableRelation.srcTableCol);
		_parentThis.dbTableRelation.linkTableConditions.push(_parentThis.dbTableRelation.targetTableCol);

	}
	
	this.redrawConnector = function () 
	{
		var jq_srcObj = _parentThis.srcObj.jq_tableRow;
		
		var targetObj =  $(_parentThis.targetElm);
		var srcOffset = $(jq_srcObj).offset();
		var destOffset = $(_parentThis.targetElm).offset();
		
		var divSCrollTop = $("#_tables_").scrollTop();
		var divScrollLeft = $("#_tables_").scrollLeft();
		
		srcOffset.left += divScrollLeft - $("#_tables_").offset().left;
		srcOffset.top += divSCrollTop - $("#_tables_").offset().top;
		
		destOffset.left += divScrollLeft - $("#_tables_").offset().left;
		destOffset.top += divSCrollTop - $("#_tables_").offset().top;
		
		var srcWidth =  $(jq_srcObj).width();
		var srcHeight = $(jq_srcObj).height();
		var targetWidth = $(targetObj).width();
		var targetHeight = $(targetObj).height();
		
		var x1, x2;
		var y1 = srcOffset.top + ($(jq_srcObj).height() / 2);
		var y2 = destOffset.top + ($(targetObj).height() / 2);
		
		if ((srcOffset.left + srcWidth) < destOffset.left)
			x1 = srcOffset.left + srcWidth;
		else
			x1 = srcOffset.left;
		
		if (destOffset.left > x1)
			x2 = destOffset.left;
		else
			x2 = destOffset.left + targetWidth;
		
		
		var pathStr = "M" + x1 + " " + y1 + " L" + x2 + " " + y2;
		
		if (_parentThis.connector == undefined)
		{
			_parentThis.connector = canvas.path(pathStr);
			_parentThis.connector.attr({
				"stroke-width" : 5,
				"stroke-linecap" : "butt",
				"stroke-linejoin" : "bevel",
				"stroke" : "#CCCCCC",
			});
			
			_parentThis.rf_remove = canvas.image("image/XButton.png",10,10,10,10);
			$(_parentThis.rf_remove.node).css({cursor:'crosshair'});
			
			_parentThis.rf_remove.hover(function (event) {
				showToolTip(event, "Delete relationship");
			}, 
			function (event) {
				hideToolTip();
				displayStatus("");
			});
	
			_parentThis.rf_remove.click(_parentThis.removeConnector);
		}
		else
		{
			_parentThis.connector.attr({
								  path : pathStr
								   });
		}
		
		var len = _parentThis.connector.getTotalLength() / 2;
		var pointAtHalfLen = _parentThis.connector.getPointAtLength(len);
		_parentThis.rf_remove.attr({
			x: pointAtHalfLen.x-5,
			y: pointAtHalfLen.y-5,
		});
		
	}
	
	this.onDBClick = function(event)
	{
		createRelationDialog(_parentThis, event.clientX, event.clientY);
	}
	
	this.hoverIn = function (event)
	{
		displayStatus("Double click to edit relationship. Click on the image at the center to delete relationship");

		var targetUIObj =  $(_parentThis.targetElm).data(_uiObjKeyName);
		var	srcUIObj	=	_parentThis.srcObj;
		var tip = srcUIObj.col.name + " <-> " + targetUIObj.col.name;
		showToolTip(event, tip);
	}
	
	this.hoverOut = function (event)
	{
		displayStatus("");
		hideToolTip();
	}
	
	this.removeConnector = function(event){
		showConfirmation("Are you sure you want to delete this connector ?",_parentThis.removeConnectorHelper,
		 "Delete ?");
	}
	
	this.removeConnectorHelper = function ()
	{
		_parentThis.connector.remove();
		_parentThis.rf_remove.remove();
		
		var targetUIObj =  $(_parentThis.targetElm).data(_uiObjKeyName);
		var	srcUIObj	=	_parentThis.srcObj;
		
		removeFromArray(srcUIObj.dbTable.relations, _parentThis.dbTableRelation);
		removeFromArray(targetUIObj.dbTable.relations, _parentThis.dbTableRelation);
		
		targetUIObj.removeConnector(_parentThis);
		srcUIObj.removeConnector(_parentThis);
	}
	
	this.init();
}

