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

_tableTableClassName = "dbTable";
_tableDivClassName = "tableDiv";
_tableHeaderClassName = "dbTableHeader";
_tableRowClassName = "dbTalbeRow";
_tableRowHighlightClassName = "rowHighlight";
_topTableDivId = "_tables_";
_orgSrcHtmlElmKeyName = "orgobj";
_uiObjKeyName = "uiobj";
_draggedColClassName = "dragCol";



function tableUI(dbTable)
{
	this.dbTable = dbTable;
	this.tableId;
	this.jq_tableDiv;
	this.jq_header;
	this.jq_rows = new Array();
	
	var _tableUI = this;
	
	this.init = function()
	{
		//make sure that div with id _tables_ exists
		if ($("div#" + _topTableDivId).length == 0)
		{
			alert ("Div with id " + _topTableDivId + " must be declared in the page");
			return null;
		}		
		
		_tableUI.tableId = createTableId(this.dbTable);
		var tableHtml = "<div class='" + _tableDivClassName + "'><table width='100%' class='" + 
				_tableTableClassName + "' id = '" + _tableUI.tableId + "'></table>";
				
		_tableUI.jq_tableDiv = $(tableHtml).appendTo("div#" + _topTableDivId).resizable({
			resize : _tableUI.onTableResize,
		});
		
		var hash_TableId = "#" + _tableUI.tableId;
		
		//create table header
		_tableUI.jq_header = new tableHeaderUI(_tableUI);
		
		$.each(_tableUI.dbTable.cols, function (index, col)
		{
			var tblRowUI = new tableRowUI (_tableUI, col);
			_tableUI.jq_rows.push(tblRowUI);
		});
		
		$(_tableUI.jq_tableDiv).mousedown(_tableUI.startDrag);
		$(_tableUI.jq_tableDiv).mouseup(_tableUI.endDrag);

	}
	
	this.startDrag = function (event)
	{
		var tablesDiv = $("#_tables_");
		
		$(_tableUI.jq_tableDiv).draggable({
   			drag: _tableUI.onDrag,
			containment: [tablesDiv.offset().left, tablesDiv.offset().top, (tablesDiv.width()-10), (tablesDiv.height()-10)],
		});
	}
	
	this.endDrag = function (event)
	{
		//$(_tableUI.jq_tableDiv).draggable("destroy");
		verifyCanvasSize(_tableUI, true);
	}
	
	this.onDrag = function (event)
	{
		_tableUI.redrawConnections();
	}
	
	this.onTableResize = function (event)
	{
		$.each(_tableUIs, function (index, tableUI)
		{
			$.each(tableUI.jq_rows, function (index1, row)
			{
				row.redrawConnectors();
			});
		});
	}
	
	this.redrawConnections = function ()
	{
		//update connector positions
		$.each(_tableUI.jq_rows, function (index, rowUI)
	    {
			rowUI.redrawConnectors();
	    });
	}
	
	this.init();
}

function tableHeaderUI(tableUI)
{
	this.dbTable = tableUI.dbTable;
	this.hash_TableId = "#" + tableUI.tableId;
	this.headerJQ;
	this.tblUI = tableUI;
	
	var _parentThis = this;
	
	
	this.init = function ()
	{
		_parentThis.headerJQ = $("<tr class='" + _tableHeaderClassName + 
								 "'><th>" + _parentThis.dbTable.name + "</th></tr>").appendTo(_parentThis.hash_TableId);
		$(_parentThis.headerJQ).mousedown(_parentThis.onMouseDown);
		$(_parentThis.headerJQ).mouseup(_parentThis.onMouseUp);
		$(_parentThis.headerJQ).dblclick(_parentThis.onDoubleClick);
		$(_parentThis.headerJQ).hover(function(event){
			displayStatus("Drag table header to move the table. Double click header to edit the table");
		}, function (event){
			displayStatus("");
		});
	}
	
	this.onMouseDown = function (event)
	{
		_parentThis.tblUI.startDrag();
	}
	
	this.onMouseUp = function (event)
	{
		_parentThis.tblUI.endDrag();
	}
	
	this.onDoubleClick = function (event)
	{
		createTableEditor(_parentThis.dbTable, $(this).offset());
		event.stopPropagation();
	}
	
	this.init();
}

__currDragRow = null;
function tableRowUI (tableUI, col)
{
	this.dbTable = tableUI.dbTable;
	this.hash_TableId = "#" + tableUI.tableId;
	this.col = col;
	this.jq_tableRow;
	this.jq_col;
	this.connectors = new Array();
	
	var _parentThis = this;
	
	this.init = function ()
	{
		if (_parentThis.dbTable.cfcName == undefined)
			_parentThis.dbTable.cfcName = _parentThis.dbTable.name;
			
		_parentThis.jq_tableRow = $("<tr class='" + _tableRowClassName + 
								"'></tr>").appendTo(_parentThis.hash_TableId);
		$(_parentThis.jq_tableRow).click(_parentThis.onRowClick);
		
		$(_parentThis.jq_tableRow).hover(function(event){
			displayStatus("Drag column name and drop onto column in other table to create relationship");
		}, function (event){
			displayStatus("");
		});
		
		_parentThis.jq_col = $("<td>" + _parentThis.col.name + "</td>").appendTo(_parentThis.jq_tableRow);
		
		_parentThis.jq_col.data(_uiObjKeyName, _parentThis);
		
		$(_parentThis.jq_col).draggable({helper: 
			function (event)
			{
				return $(event.currentTarget).clone().css("zIndex", 1).
					addClass(_draggedColClassName).
					data(_uiObjKeyName, _parentThis).
					data(_orgSrcHtmlElmKeyName, event.currentTarget);
			},
			
			start: _parentThis.onRowDragStart,
			
		});
		
		$(_parentThis.jq_col).droppable({drop : _parentThis.onRowDrop});

	}
	
	this.onRowClick = function (event)
	{
		$(_parentThis.jq_tableRow).parent().children("tr").removeClass(_tableRowHighlightClassName);
		$(_parentThis.jq_tableRow).addClass(_tableRowHighlightClassName);
		event.stopPropagation();
	}
	
	this.onRowDrop = function(event, ui)
	{
		srcElement = __currDragRow;
		
		if ($(srcElement).data(_orgSrcHtmlElmKeyName).dbTable.name == $(this).data(_uiObjKeyName).dbTable.name ||
			_parentThis.isDuplicateRelation($(srcElement).data(_orgSrcHtmlElmKeyName), $(this).data(_uiObjKeyName)))
			return;
		
		var connector = new connectorUI($(srcElement), $(this));
		__currDragRow = null;
	}
	
	this.isDuplicateRelation = function (srcRowUI, targetRowUI)
	{
		var dbTable1 = srcRowUI.dbTable;
		var dbTable2 = targetRowUI.dbTable;
		
		if (dbTable1.relations.length == 0 || dbTable2.relations.length == 0)
			return false;
		
		var col1 = srcRowUI.col;
		var col2 = targetRowUI.col;
		
			
		for (var i = 0; i < dbTable1.relations.length; i ++)
		{
			var rel = dbTable1.relations[i];
			
			if (rel.srcTableCol.col.name == col1.name && rel.targetTableCol.table.name == dbTable2.name &&
			 	rel.targetTableCol.col.name == col2.name)
				return true;
		}
		
		return false;
	}
	
	this.onRowDragStart = function (event)
	{
		__currDragRow = _parentThis.jq_tableRow;
		$(__currDragRow).data(_orgSrcHtmlElmKeyName, _parentThis);
	}
	
	this.redrawConnectors = function()
	{
		$.each(_parentThis.connectors, function (index, connector)
		{
			connector.redrawConnector();
		});
	}
	
	this.removeConnector = function (con)
	{
		$.each(_parentThis.connectors, function (index, item)
		{
			if (item == con)
			{
				_parentThis.connectors.splice(index,1);
				return false;
			}
		});
	}
	
	this.init();
}

