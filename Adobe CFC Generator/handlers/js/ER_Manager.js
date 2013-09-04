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

toolTipId = "toolTip";

_tableUIs = Array();

_canvas = null;

_postUrl = null;

_msgDlg = null;
_msgDiv = null;

_helpDlg = null;
_helpDlgClass="_helpDlg";
_helpDlgDiv="_helpDlgDiv";

_maxX = 0;
_maxY = 0;

function start(dbTables)
{
	canvas = Raphael ("_tables_",$(window).width(),$(window).height());

	arrangePageLayout();
	
	$(window).resize(onDocumentResize);
	
	$("#_tables_").scroll(onTableDivScroll);
	
	//create generate code button
	var genBtnStr = "<div id='codeGenBtnDiv'><image id='generateBtn' src='image/Generate-Button-Over.png'></image></div>";
	
	$(genBtnStr).appendTo("#_footer_");
	var codeGenBtn = $("#generateBtn");
	codeGenBtn.click(generateCode);
//	codeGenBtn.hover(function(event){
//		$(this).attr("src", "image/Generate-Button-Over.png");
//	}, function(event){
//		$(this).attr("src", "image/Generate-Button-Normal.png");
//	});

	codeGenBtn.mousedown(function (event){
		$(this).attr("src", "image/Generate-Button-Down.png");
	});
	codeGenBtn.mouseup(function (event){
		$(this).attr("src", "image/Generate-Button-Over.png");
	});
	
//	$("#helpLink").hover(function(event){
//		$(this).attr("src", "image/Help-Button-Over.png");
//	}, function(event){
//		$(this).attr("src", "image/Help-Button-Normal.png");
//	});

	$("#helpLink").mousedown(function (event){
		$(this).attr("src", "image/Help-Button-Down.png");
	});
	$("#helpLink").mouseup(function (event){
		$(this).attr("src", "image/Help-Button-Over.png");
	});

	$.each(dbTables, function (index, dbTable)
	{
		var tblui = new tableUI(dbTable);
		_tableUIs.push(tblui);
	});
	
	$("#helpLink").click(displayHelp);
	
	arrangeTables();
	
	setupConnectorToolTip();

	computeMaxCanvasSize();
}

function dbTable()
{
	this.name;
	this.cfcName;
	this.cols = new Array();
	this.relations = new Array();
}

function dbColumn()
{
	this.name;
	this.type;
	this.length;
	this.isPrimaryKey = false;
	this.isForeignKey = false;
	this.propertyType;
	this.propertyName;
	this.isSelected = true;
}

function dbRelation()
{
	this.srcRelName;
	this.srclMultiplicity = "1-1"; //multiplicity
	this.targetRelName;
	this.targetMultiplicity = "1-1"; 
	this.srcRelEnabled = true;
	this.targetRelEnabled = true;
	
	this.linkTable;
	this.linkTableConditions = new Array();	
	this.srcTableCol;
	this.targetTableCol;
	this.srcTable;
	this.targetTable;
}

function dbTableColPair(tbl, column)
{
	this.table = tbl;
	this.col = column;
}

function createTableId (tableObj)
{
	return "_" + tableObj.name.split(' ').join('') + "_id";
}

function _createColumn (table, name, type, length, isPrimaryKey, cfcFieldType)
{
	var col = new dbColumn();
	col.name = name;
	col.type = type;
	col.length = length;
	if (cfcFieldType != undefined)
		col.propertyType = cfcFieldType;
	else
		col.propertyType = type;
	col.propertyName = col.name;
	if (isPrimaryKey == undefined)
		col.isPrimaryKey = false;
	else
		col.isPrimaryKey = isPrimaryKey;
	col.isSelected = true;
	table.cols.push(col);
	return col;
}

function _createTable (name)
{
	var table = new dbTable();
	table.name = name;
	return table;
}

function arrangeTables()
{
	var x = 0, y = $("#_header_").height();
	var xGap = 50, yGap = 20;
	
	$.each(_tableUIs, function (index, tableUI)
	{
		var position = $(tableUI.jq_tableDiv).offset();
		var width = $(tableUI.jq_tableDiv).width();
		var height = $(tableUI.jq_tableDiv).height();
		var newX = x + xGap;
		x = newX + width;
		var newY = y;
		$(tableUI.jq_tableDiv).offset({top : y, left : newX});
	});
}

function setupConnectorToolTip()
{
	var tip = "<div id='" + toolTipId + "'> </div>";
	$("body").append(tip);
	
}

function cloneObject (obj, excludeArray)
{
  var newObj = (obj instanceof Array) ? [] : {};
  for (mem in obj) 
  {
    if (mem == 'clone') 
		continue;
		
	if (excludeArray != undefined && $.inArray(excludeArray, mem))
		newObj[mem] = obj[mem]
    else if (obj[mem] && typeof obj[mem] == "object") 
	{
      newObj[mem] = cloneObject(obj[mem]);
    } 
	else 
		newObj[mem] = obj[mem]
  } 
  return newObj;	
}

function generateCode()
{
	if (_postUrl == undefined)
	{
		showMessage("No CFML URL specified to process this request", "Error");
		return;	
	}
	
	var jsonStr = "";
	
	var tmpTables = Array();
	
	$.each(_tableUIs, function(index, tblUIArg){
		tmpTables.push(tblUIArg.dbTable);
	});
	
	var jsonStr = serializeDBTablesToJSON(tmpTables);
	
	$.post(_postUrl, {
		data: jsonStr,
	},onCodeGenSuccess);
	
}

function onCodeGenSuccess(data)
{
	showMessage(data, "Message");
}

function setPostUrl(postUrl)
{
	_postUrl = postUrl;
}

function _createMessageDiv()
{
	if (_msgDiv == undefined)
	{
		var txt = "<div id='msgDiv'></div>";
		_msgDiv = $(txt).appendTo("body");
	} 
	
}

function showMessage(message, title)
{
	_createMessageDiv();
	
	if (title == undefined)
		title = "Message";
		
	_msgDlg = $("#msgDiv").dialog({title : title, modal : true, buttons : {}});
	_msgDiv.html(message);
}

function showConfirmation (message, okFunction, title)
{
	_createMessageDiv();

	if (title == undefined)
		title = "Message";
	
	var confDlg = $("#msgDiv"). dialog ({
		modal : true,
		title : title,
		buttons : {
			"Yes" : function()
			{
				okFunction();
				$(this).dialog("close");
			},
			"No" : function ()
			{
				$(this).dialog("close");
			},	
		},
	});
	
	_msgDiv.html(message);
}

function removeFromArray (arrayObj, elmToRemove)
{
	for (var i = 0; i < arrayObj.length; i++)
	{
		if (arrayObj[i] == elmToRemove)
		{
			arrayObj.splice(i,1);
			return true;
		}
	}
	
	return false;
}

function onTableDivScroll (event)
{
	redrawAllConnectors();
}

function redrawAllConnectors()
{
	$.each(_tableUIs, function(index, tableUI){
		tableUI.redrawConnections();
	});
}

function displayStatus(message)
{
	$("#_status_").html(message);
}

function arrangePageLayout()
{
	var tablesDivHeight = $(window).height() - $("#_header_"). height() - $("#_footer_").height() - 22;
	
	$("#_tables_").css({height : tablesDivHeight + "px"});
}

function onDocumentResize()
{
	arrangePageLayout();
	computeMaxCanvasSize();
}

function showToolTip(event, tip)
{
	var x = event.clientX + 10;
	var y = event.clientY - 10;
	
	$("#"+toolTipId).
		css({zindex : 0, position : "absolute", left : x, top : y}).
		html(tip).
		show();
}

function hideToolTip ()
{
	$("#"+toolTipId).hide();
}
	
function displayHelp(event)
{
	if (_helpDlg == undefined)
	{
		var pageContent = $.get("help.html", function(data){
			$(_helpDlg).html(data);
		});
		
		var dlgDiv = "<div id='" + _helpDlgDiv + "'>" +
		"</div>";
		$("body").append(dlgDiv);
		_helpDlg  = $("#" + _helpDlgDiv).dialog({
			dialogClass : "_helpDlg",
			autoOpen : false,
			height : 450,
			width : 550,
			modal : false,
			title : 'Adobe CFC Generator Help',
			buttons : {
				"Close" : function() {
					_helpDlg.dialog("close");				
				},
			},
		});
	}
	_helpDlg.dialog("open");
	return false;
}

function computeMaxCanvasSize()
{
	var oldX = _maxX;
	var oldY = _maxY;
	
	$.each(_tableUIs, function (index, tableUI){
		verifyCanvasSize(tableUI);
	});
	
	if (_maxX > oldX || _maxY > oldY)
		canvas.setSize(_maxX, _maxY);
}

function verifyCanvasSize (tableUI, doResize)
{
	var offset =  tableUI.jq_tableDiv.offset();
	var divSCrollTop = $("#_tables_").scrollTop();
	var divScrollLeft = $("#_tables_").scrollLeft() ;
	
	var x = offset.left + tableUI.jq_tableDiv.width() + divScrollLeft;
	var y = offset.top + tableUI.jq_tableDiv.height() + divSCrollTop + $("#_header_").height();

	var resize = false;
	if (_maxX < x) {
		_maxX = x + 20;
		resize = true;
	}
	if (_maxY < y) {
		_maxY = y + 20;
		resize = true;
	}
	if (doResize != undefined && resize == true)
		canvas.setSize(_maxX, _maxY);
}
